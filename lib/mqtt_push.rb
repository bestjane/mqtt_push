require "mqtt_push/version"

module MqttPush
## 推送消息辅助方法
# 1. 可自定义can_push?和push_message_json_data method
#    可在对应class中通过定义can_push?方法指定推送规则,
#    如果不需要定义规则则不用定义can_push?
# 2. push_message_json_data 定义json数据
  PUSH_NOTIFY_APP_KEY = '6727fb0922117931bb65a48ee27dc0d9'

  def push_notify
    check_auth = self.respond_to?(:can_push?) ? can_push? : true
    return unless check_auth

    send_mqtt_message = Proc.new do | user |
      begin
        data = push_message_json_data
        Rails.logger.error "mqtt error: data:#{data}, user_id: #{user.id}, usernmae: #{user.username}" unless data && user
        msg = {
                timestamp: Time.now.to_i,
                ticket: user.ticket,
                payload: {
                  body: {
                          title: data[:title],
                          text: data[:text],
                          after_open: data[:after_open],
                          after_open_page: data[:after_open_page]
                        },
                  extra: data[:extra],
                  display_type: data[:display_type] || 'notification',
                  play_sound: data[:play_sound] ||'true'
                }
              }
        # title, text, after_open, after_open_page为加密字段
        sign_json = msg[:payload][:body].merge!(timestamp: msg[:timestamp])
        msg.merge!(sign: sign(sign_json))
        $mqtt.publish(topic(user.id), msg.to_json)
        Rails.logger.info "mqtt push message: topic:#{topic(user.id)}, msg:#{msg.to_json}"
      rescue StandardError => e
        Rails.logger.error "mqtt push message error: #{e}"
      end
    end
    send_mqtt_message.call(user)
  end

  private
  def sign(msg)
    data = msg.select{ |_, v| v.present? }.sort.map { |k, v| "#{k}=#{v}"}.join('&') + "&key=#{PUSH_NOTIFY_APP_KEY}"
    Digest::MD5.hexdigest(data).upcase
  end

  def topic(u_id)
    "/users/#{u_id}/message"
  end

end
