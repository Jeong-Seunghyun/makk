package kr.co.makkan.board.mapper;

import java.util.List;

import kr.co.makkan.board.domain.BoardDTO;
import kr.co.makkan.board.domain.FileDTO;
import kr.co.makkan.board.domain.PageDTO;
import kr.co.makkan.board.domain.ReplyDTO;

public interface BoardMapper {
	public int totalPostCnt();
	public List<BoardDTO> allPostList(PageDTO pDto);
	public List<BoardDTO> allNoticeList();
	public BoardDTO selPostView(int postNo);
	public List<FileDTO> selAttach(int postNo);
	public void addPost(BoardDTO bDto);
	public void addNotice(BoardDTO bDto);
	public int selectMaxNum();
	public void addAttach(FileDTO fileList);
	public void removeAttach(int postNo);
	public void deletePost(int postNo);
	public void deleteAllReply(int postNo);
	public void modifyPost(BoardDTO bDto);
	public void addReply(ReplyDTO rDto);
	public List<ReplyDTO> selAllReply(ReplyDTO rDto);
	public void modifyReply(ReplyDTO rDto);
	public void removeReply(int replyNo);
	public List<FileDTO> getOldFiles();
}
