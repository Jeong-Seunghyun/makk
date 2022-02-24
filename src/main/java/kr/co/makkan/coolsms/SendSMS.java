package kr.co.makkan.coolsms;

import java.util.HashMap;

import org.json.simple.JSONObject;

import lombok.extern.log4j.Log4j;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@Log4j
public class SendSMS {
	public void sendAction(String phoneNum, int randomNumber) {
		
		String api_key = "NCS2H5E9YVXC50M4";
		String api_secret = "BSBYXOQ3A5ITKWESBK4Q9FZYNNZ0J0NV";
		Message coolsms = new Message(api_key, api_secret);
		// 4 params(to, from, type, text) are mandatory. must be filled


		HashMap<String, String> params = new HashMap<String, String>();

		params.put("to", phoneNum); // 받는 번호
		params.put("from", "01045670720"); // 무조건 자기번호 (인증)
		params.put("type", "SMS");
		params.put("text", "본인확인 인증번호 [" + randomNumber + "] 입력시 정상처리 됩니다.");
		params.put("app_version", "test app 1.2");
		// application name and version

		try { // send() 는 메시지를 보내는 함수
			JSONObject obj = (JSONObject) coolsms.send(params);
			log.info(obj);
		} catch (CoolsmsException e) {
			log.error(e.getMessage());
			log.error(e.getCode());
		}

	}
}
