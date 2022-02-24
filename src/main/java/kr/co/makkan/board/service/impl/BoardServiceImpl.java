package kr.co.makkan.board.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.makkan.board.domain.BoardDTO;
import kr.co.makkan.board.domain.FileDTO;
import kr.co.makkan.board.domain.PageDTO;
import kr.co.makkan.board.domain.ReplyDTO;
import kr.co.makkan.board.mapper.BoardMapper;
import kr.co.makkan.board.service.IBoardService;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class BoardServiceImpl implements IBoardService{
	
	@Autowired
	private BoardMapper mapper;
	
	@Override
	public int totalPostCnt() {
		log.info("get total post count-----");
		return mapper.totalPostCnt();
	}

	@Override
	public List<BoardDTO> selAllPostList(PageDTO pDto) {
		log.info("get all post list----------");
		List<BoardDTO> boardList = mapper.allPostList(pDto);
		ReplyDTO rDto = new ReplyDTO();
		for (BoardDTO boardDTO : boardList) {
			rDto.setPostNo(boardDTO.getPostNo());
			boardDTO.setReplyList(mapper.selAllReply(rDto)); 
		}
		return boardList;
	}

	@Override
	public List<BoardDTO> selAllNoticeList() {
		log.info("get all notice post list----------");
		return mapper.allNoticeList();
	}

	@Override
	public BoardDTO selPostView(int postNo, int count) { //게시글 상세 보기
		log.info("Post View------------");
		BoardDTO bDto = mapper.selPostView(postNo);
		List<FileDTO> fileList = mapper.selAttach(postNo); //글에 첨부파일이 있는지 확인
		ReplyDTO rDto = new ReplyDTO();
		rDto.setPostNo(postNo);
		rDto.setStartNum(count);
		rDto.setEndNum(count);
		List<ReplyDTO> replyList = mapper.selAllReply(rDto);
		if (fileList != null) {
			bDto.setFileList(fileList);
		}
		if (replyList != null) {
			bDto.setReplyList(replyList);
		}
		return bDto;
	}
	
	@Transactional
	@Override
	public void addPost(BoardDTO bDto) {
		mapper.addPost(bDto);
		int postNo = mapper.selectMaxNum(); //새글 작성.. board테이블에서 마지막 시퀀스값 가져와 세팅.. 개선 필요
		List<FileDTO> fileList = bDto.getFileList();
		if (fileList != null) {
			for (FileDTO fileDTO : fileList) {
				fileDTO.setPostNo(postNo);
				mapper.addAttach(fileDTO);
			}	
		}
	}
	
	@Transactional
	@Override
	public void addNotice(BoardDTO bDto) {
		mapper.addNotice(bDto);
		int postNo = mapper.selectMaxNum();
		List<FileDTO> fileList = bDto.getFileList();
		if (fileList != null) {
			for (FileDTO fileDTO : fileList) {
				fileDTO.setPostNo(postNo);
				mapper.addAttach(fileDTO);
			}	
		}
	}

	@Transactional
	@Override
	public void modifyPost(BoardDTO bDto) {
		
		mapper.removeAttach(bDto.getPostNo()); //기존 첨부파일 삭제
		mapper.modifyPost(bDto); //글 내용 업데이트
		
		List<FileDTO> fileList = bDto.getFileList();
		if (fileList != null) {
			for (FileDTO fileDTO : fileList) {
				fileDTO.setPostNo(bDto.getPostNo());
				mapper.addAttach(fileDTO);
			}	
		}
		
	}

	@Override
	public void addReply(ReplyDTO rDto) {
		mapper.addReply(rDto);
	}

	@Override
	public void modifyReply(ReplyDTO rDto) {
		mapper.modifyReply(rDto);
		
	}

	@Override
	public List<ReplyDTO> selReplyList(ReplyDTO rDto) {
		return mapper.selAllReply(rDto);
	}
	
	@Transactional
	@Override
	public void deletePost(int postNo) {
		mapper.removeAttach(postNo);
		mapper.deletePost(postNo);
		mapper.deleteAllReply(postNo);
	}
	
	@Override
	public void removeReply(int replyNo) {
		mapper.removeReply(replyNo);
	}

}
