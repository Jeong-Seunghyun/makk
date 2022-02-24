package kr.co.makkan.controller;

import java.io.File;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.makkan.board.domain.FileDTO;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/file")
public class FileController {

	private static final String UPLOAD_PATH = "C:\\Users\\82104\\Documents\\workspace-spring-tool-suite-4-4.10.0.RELEASE\\makkan\\src\\main\\webapp\\resources\\attach\\";

	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/uploadFile", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<FileDTO>> upload(MultipartFile[] multiFile) {
		log.info("file upload--------------");

		List<FileDTO> attachList = new ArrayList<FileDTO>();
		String uploadFolderPath = getFolder();

		File uploadFolder = new File(UPLOAD_PATH, getFolder());

		log.info("uploadFolder................" + uploadFolder);
		//날짜 경로의 이름인 폴더가 없을때 생성
		if (uploadFolder.exists() == false) {
			uploadFolder.mkdirs();
		}

		for (MultipartFile multipartFile : multiFile) {
			FileDTO fileDTO = new FileDTO();
			String uploadFileName = multipartFile.getOriginalFilename();
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);

			fileDTO.setFileName(uploadFileName);

			UUID uuid = UUID.randomUUID();

			uploadFileName = uuid.toString() + "_" + uploadFileName;

			try {
				File saveFile = new File(uploadFolder, uploadFileName);
				multipartFile.transferTo(saveFile);

				fileDTO.setUuid(uuid.toString());
				fileDTO.setUploadPath(uploadFolderPath);
				attachList.add(fileDTO);
			} catch (Exception e) {
				log.error(e.getMessage());
				e.printStackTrace();
			}
		}
		return new ResponseEntity<List<FileDTO>>(attachList, HttpStatus.OK);
	}

	private String getFolder() { // 해당 날짜 파일경로 취득
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}

	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName) {
		log.info("deleteFile : " + fileName);

		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "text/html;charset=UTF-8");

		try {
			File file = new File(UPLOAD_PATH + "\\" + URLDecoder.decode(fileName, "UTF-8"));

			file.delete();
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted", headers, HttpStatus.OK);
	}
}
