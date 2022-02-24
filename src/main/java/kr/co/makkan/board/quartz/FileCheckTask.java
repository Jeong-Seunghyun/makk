package kr.co.makkan.board.quartz;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.co.makkan.board.domain.FileDTO;
import kr.co.makkan.board.mapper.BoardMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	private String fileDir = "C:\\Users\\82104\\Documents\\workspace-spring-tool-suite-4-4.10.0.RELEASE\\makkan\\src\\main\\webapp\\resources\\attach";
	
	@Setter(onMethod_ = {@Autowired})
	private BoardMapper mapper;
	
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String str = sdf.format(cal.getTime());
		return str.replace("-", File.separator);
	}
	
	@Scheduled(cron = "0 0 9 * * *") // 0초, 0분 , 9시에 실행
	public void checkFiles() throws Exception{
		log.warn("File Check Task run...............");
		log.warn(new Date());
		
		//DB내 파일 목록
		List<FileDTO> fileList = mapper.getOldFiles();
		
		//디렉토리 파일의 목록
		List<Path> fileListPaths = fileList.stream().map(dto -> Paths
				.get(fileDir ,dto.getUploadPath(), dto.getUuid() + "_" + dto.getFileName()))
				.collect(Collectors.toList());

		fileListPaths.forEach(p -> log.warn(p));
		
		//어제 날짜 경로에 있는 파일 목록
		File targetDir = Paths.get(fileDir, getFolderYesterDay()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		for (File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
	}
}
