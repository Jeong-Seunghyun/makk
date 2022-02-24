package kr.co.makkan.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.makkan.board.domain.BoardDTO;
import kr.co.makkan.board.domain.FileDTO;
import kr.co.makkan.board.domain.PageDTO;
import kr.co.makkan.board.domain.PageMaker;
import kr.co.makkan.board.domain.ReplyDTO;
import kr.co.makkan.board.service.IBoardService;
import kr.co.makkan.member.domain.MemberDTO;
import kr.co.makkan.member.service.IMemberService;
import lombok.extern.log4j.Log4j;

@Log4j
@RequestMapping("/board")
@Controller
public class BoardController {
	
	@Autowired
	IBoardService boardServ;
	@Autowired
	IMemberService service;
	
	@GetMapping() //게시판 메인화면
	public String boardList(PageDTO pDto , Model model) {
		
		log.info("board list---------");
		int total = boardServ.totalPostCnt(); // 삭제되거나 공지글을 제외한 총 게시글 수 조회
		
		//페이징을 위한 DTO 세팅,, page와 총 건수만 파라미터로 넘기면 자동세팅
		int page = pDto.getPage();
		pDto = new PageDTO(page, total);

		List<BoardDTO> postList = boardServ.selAllPostList(pDto);
		List<BoardDTO> noticeList = boardServ.selAllNoticeList();
		PageMaker pMaker = new PageMaker();
		pMaker.setPaging(pDto);
		for (BoardDTO boardDTO : postList) { //사용자 이름 비공개를 위한 마스킹처리
			String userName = boardDTO.getWriterName();
			if (userName.length() == 2) {
				boardDTO.setWriterName(userName.substring(0,1)+"*");
			}else if (userName.length() == 3) {
				boardDTO.setWriterName(userName.substring(0,1)+"*"+userName.substring(2,3));
			}else if (userName.length() > 3) {
				boardDTO.setWriterName(userName.substring(0,1)+"**"+userName.substring(3,4));
			}
		}
		model.addAttribute("noticeList",noticeList);
		model.addAttribute("postList",postList);
		model.addAttribute("pageMaker", pMaker);
		
		return "/board/boardlist";
		
	}
	
	//게시글 상세
	@GetMapping("/boardview")
	public Map<String, Object> boardView(int postNo, int page, int count) {
		log.info("Board View --------- postno="+postNo);
		Map<String, Object> paraMap = new HashMap<String, Object>();
		
		//사용자가 보던 page를 함께 return함
		BoardDTO boardDTO = boardServ.selPostView(postNo, count);
		paraMap.put("page", page);
		paraMap.put("boardDTO", boardDTO);
		return paraMap;
	}
	
	//글쓰기 화면 이동
	@GetMapping("/boardform")
	public void boardForm() {
		log.info("board register form");
	}
	
	//글쓰기 submit
	@PostMapping("/register")
	public String registerPost(BoardDTO bDto, RedirectAttributes rttr) {
		log.info("save post ---------------");
		
		MemberDTO mDto = service.selectMe(bDto.getWriterId());
		bDto.setWriterName(mDto.getName());
		log.info(bDto.toString());
		
		boardServ.addPost(bDto);
		rttr.addFlashAttribute("message","게시글이 등록되었습니다.");
		
		return "redirect:/board";
	}
	
	//공지쓰기 submit
	@PostMapping("/registerNotice")
	public String registerNotice(BoardDTO bDto, RedirectAttributes rttr) {
		log.info("save post ---------------");
		
		MemberDTO mDto = service.selectMe(bDto.getWriterId());
		bDto.setWriterName(mDto.getName());
		log.info(bDto.toString());
		
		boardServ.addNotice(bDto);
		rttr.addFlashAttribute("message","공지글이 등록되었습니다.");
		
		return "redirect:/board";
	}
	
	//글 수정 submit
	@PostMapping("/modifyAction")
	public String modify(BoardDTO bDto, int page, RedirectAttributes rttr) {
		log.info("save modify-----------");
		log.info(bDto.toString());
		//기존 등록된 파일 + 새로 등록한 첨부파일.. null값인 컬렉션은 삭제
		List<FileDTO> newArr = bDto.getFileList();
		if (newArr != null) {
			Iterator it = newArr.iterator();
			while (it.hasNext()) {
				FileDTO n = (FileDTO) it.next();
				if (n.getFileName()==null) {
					it.remove();
				}
			}
			for (FileDTO fileDTO : newArr) {
				log.info(fileDTO.toString());
			}
			//첨부파일 개수가 6개 이상이면 return,,,
			if (newArr.size() > 5) {
				rttr.addFlashAttribute("message", "이미지 파일은 5개까지만 등록가능합니다.");
				return "redirect:/board/boardview?postNo="+bDto.getPostNo()+"&page="+page+"&count=1";
			}
		}
		
		bDto.setFileList(newArr);
		
		boardServ.modifyPost(bDto);
		
		rttr.addFlashAttribute("message", "글이 수정되었습니다.");
		return "redirect:/board";
	}
	
	//댓글 작성
	@PostMapping("/addReply")
	public String addReply(ReplyDTO rDto, String writerId, int page , RedirectAttributes rttr) {
		log.info("reply add Action ----------");
		rDto.setReplyerId(writerId);
		boardServ.addReply(rDto);
		rttr.addFlashAttribute("message", "댓글이 등록되었습니다.");
		return "redirect:/board/boardview?postNo="+rDto.getPostNo()+"&page="+page+"&count=1";
	}
	
	//댓글 수정
	@PostMapping("modifyReply")
	public String modifyReply(int realReplyNo , ReplyDTO rDto, String replyText, RedirectAttributes rttr) {
		log.info("reply modify--------------");
		log.info(realReplyNo);
		rDto.setReplyNo(realReplyNo);
		rDto.setReply(replyText);
		boardServ.modifyReply(rDto);
		rttr.addFlashAttribute("message","댓글이 수정되었습니다.");
		return "redirect:/board";
	}
	
	//무한스크롤 감지시 댓글 목록 출력
	@GetMapping("/infiReply")
	public ResponseEntity<List<ReplyDTO>> infiReply(int postNo, int count) {
		log.info("New reply List-----------");
		List<ReplyDTO> replyList = new ArrayList<ReplyDTO>();
		ReplyDTO rDto = new ReplyDTO();
		rDto.setPostNo(postNo);
		rDto.setEndNum(count);
		rDto.setStartNum(count);
		replyList = boardServ.selReplyList(rDto);
		if (replyList.size() < 1) {
			return null;
		}
		
		return new ResponseEntity<List<ReplyDTO>>(replyList, HttpStatus.OK);
	}
	
	//게시글 삭제
	@PostMapping("/deletePost")
	public String deletePost(int postNo, RedirectAttributes rttr) {
		log.info("delete post--------");
		boardServ.deletePost(postNo);
		rttr.addFlashAttribute("message", postNo + "번 글이 삭제되었습니다.");
		return "redirect:/board";
	}
	
	// 댓글 삭제
	@PostMapping("removeReply")
	public String deleteReply(int postNo, int page, int realReplyNo, RedirectAttributes rttr) {
		String url = "redirect:/board/boardview?postNo="+postNo+"&page="+page+"&count=1";
		log.info("Reply Remove Action ---------");
		boardServ.removeReply(realReplyNo);
		
		rttr.addFlashAttribute("message", "댓글이 삭제되었습니다.");
		return url;
	}
}
