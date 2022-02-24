package kr.co.makkan.board.domain;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class BoardDTO {
	private int postNo;
	private String writerId;
	private	String WriterName;
	private String title;
	private	String content;
	private Date reportDate;
	private char dropPost;
	private char noticePost;
	private List<FileDTO> fileList;
	private List<ReplyDTO> replyList;
}