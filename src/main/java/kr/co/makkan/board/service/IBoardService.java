package kr.co.makkan.board.service;

import java.util.List;

import kr.co.makkan.board.domain.BoardDTO;
import kr.co.makkan.board.domain.PageDTO;
import kr.co.makkan.board.domain.ReplyDTO;

public interface IBoardService {

	public int totalPostCnt();
	
	public List<BoardDTO> selAllPostList(PageDTO pDto);
	
	public List<BoardDTO> selAllNoticeList();
	
	public BoardDTO selPostView(int postNo, int count);
	
	public List<ReplyDTO> selReplyList(ReplyDTO rDto);
	
	public void addPost(BoardDTO bDto);
	
	public void addNotice(BoardDTO bDto);
	
	public void modifyPost(BoardDTO bDto);
	
	public void addReply(ReplyDTO rDto);
	
	public void modifyReply(ReplyDTO rDto);
	
	public void deletePost(int postNo);
	
	public void removeReply(int replyNo);
}
