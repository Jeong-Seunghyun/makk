package kr.co.makkan.board.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class FileDTO {
	private String fileName;
	private String uploadPath;
	private String uuid;
	private int postNo;
}
