package kr.co.makkan.board.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Data
public class PageDTO {
	private int page; //user가 요청한 페이지
	private int totalPageCnt; //총 페이지 개수
	private int totalPostCnt; //총 게시글 개수
	private int beginRowNum; //한 페이지에서 시작하는 행
	private int endRowNum; //한 페이지에서 끝나는 행
	
	public PageDTO(int page, int totalPostCnt) {
		if (page <= 0) { //선택한 페이지가 없으면 1페이지로 이동
			this.page = 1;
		}else {
			this.page = page;			
		}
		this.totalPostCnt = totalPostCnt;
		//총 페이지 개수 = ( 총 게시글 개수 / 10 )+ 1 이거나 +0
		this.totalPageCnt = totalPostCnt/10 + (totalPostCnt % 10 == 0 ? 0 : 1);
		this.beginRowNum = (this.page -1) * 10 +1;
		//10페이지를 요청하면 91번부터 시작
		if (endRowNum > this.totalPostCnt) { //마지막 글 번호가 총 게시글 개수를 넘지 않게 분기
			this.endRowNum = this.totalPostCnt;
		} else {
			this.endRowNum = this.page * 10; //10페이지의 마지막 글은 100번
		}
		
	}
}