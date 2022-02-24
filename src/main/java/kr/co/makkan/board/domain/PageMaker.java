package kr.co.makkan.board.domain;


public class PageMaker {
	
	private int beginPage;
	private int endPage;
	private boolean prev;
	private boolean next;
	private PageDTO paging;
	
	public void setPaging(PageDTO paging) {
		this.paging = paging;
		calcData();
	}
	
	private void calcData() {
		
		//섹션별 첫 페이지 번호 ( 요청 페이지 / 10 [ -1 또는 -0 ])* 10 + 1 )
		this.beginPage = (paging.getPage() / 10 - (paging.getPage() % 10 != 0 ? 0 : 1)) * 10 + 1;
		this.endPage = this.beginPage + 9 ;
		
		if (this.endPage > paging.getTotalPageCnt()) { // 실제 end페이지보다 값이 커지면 총 페이지 개수 까지만 출력
			this.endPage = paging.getTotalPageCnt();
		}
		prev = beginPage == 1 ? false : true;
		next = endPage * 10 < paging.getTotalPostCnt() ? true : false; 
		//마지막 페이지 * 10의 값과 총 게시글개수를 비교해 next를 출력
	}

	public int getBeginPage() {
		return beginPage;
	}

	public void setBeginPage(int beginPage) {
		this.beginPage = beginPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public boolean isPrev() {
		return prev;
	}

	public void setPrev(boolean prev) {
		this.prev = prev;
	}

	public boolean isNext() {
		return next;
	}

	public void setNext(boolean next) {
		this.next = next;
	}

	public PageDTO getPaging() {
		return paging;
	}
	
	
}
