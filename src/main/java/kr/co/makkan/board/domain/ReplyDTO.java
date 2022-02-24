package kr.co.makkan.board.domain;

import lombok.ToString;

@ToString
public class ReplyDTO {
	private int replyNo;
	private int postNo;
	private String reply;
	private String replyDate;
	private String replyerId;
	//댓글 무한 스크롤 처리를 위한 변수
	private int count; 
	private int startNum;
	private int endNum;
	
	public int getReplyNo() {
		return replyNo;
	}
	public void setReplyNo(int replyNo) {

		this.replyNo = replyNo;
	}
	public int getPostNo() {
		return postNo;
	}
	public void setPostNo(int postNo) { //최초 세팅을 위한 endNum과 startNum의 값을 설정
		this.endNum = 1;
		this.startNum = 1;
		this.postNo = postNo;
	}
	public String getReply() {
		return reply;
	}
	public void setReply(String reply) {
		this.reply = reply;
	}
	public String getReplyDate() {
		return replyDate;
	}
	public void setReplyDate(String replyDate){
		this.replyDate = replyDate;
	}
	public String getReplyerId() {
		return replyerId;
	}
	public void setReplyerId(String replyerId) {
		this.replyerId = replyerId;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public int getStartNum() {
		return startNum;
	}
	public void setStartNum(int count) { //무한 스크롤 이벤트 감지시 count값에 따라 startNum값 가변
		if (count < 1) {
			count = 1;
		}
		this.startNum = this.count == 1 ? count : count * 10 - 9;
	}
	public int getEndNum() {
		return endNum;
	}
	public void setEndNum(int count) { //무한 스크롤 이벤트 감지시 count값에 따라 endNum값 가변
		if (count < 1) {
			count = 1;
		}
		this.endNum = count * 10;
	}

	
}
