package com.nicico.training.controller;

import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.file.FileInfo;
import com.nicico.copper.core.util.file.FileUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.activiti.engine.RepositoryService;
import org.apache.commons.io.FilenameUtils;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import javax.imageio.stream.FileImageInputStream;
import javax.imageio.stream.ImageInputStream;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacher")
public class TeacherRestController {

	private final ITeacherService teacherService;
	private final ReportUtil reportUtil;

    @Value("${nicico.teacher.upload.dir}")
    private String teacherUploadDir;

    @Value("${nicico.temp.upload.dir}")
    private String tempUploadDir;

    private final TeacherDAO teacherDAO;


	// ------------------------------

	@Loggable
	@GetMapping(value = "/{id}")
	@PreAuthorize("hasAuthority('r_teacher')")
	public ResponseEntity<TeacherDTO.Info> get(@PathVariable Long id) {
		return new ResponseEntity<>(teacherService.get(id), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/list")
	@PreAuthorize("hasAuthority('r_teacher')")
	public ResponseEntity<List<TeacherDTO.Info>> list() {
		return new ResponseEntity<>(teacherService.list(), HttpStatus.OK);
	}

	@Loggable
	@PostMapping
	@PreAuthorize("hasAuthority('c_teacher')")
	public ResponseEntity<TeacherDTO.Info> create(@RequestBody Object request) {
		TeacherDTO.Create create = (new ModelMapper()).map(request, TeacherDTO.Create.class);
        return new ResponseEntity<>(teacherService.create(create), HttpStatus.CREATED);
	}

	@Loggable
	@PutMapping(value = "/{id}")
	@PreAuthorize("hasAuthority('u_teacher')")
	public ResponseEntity<TeacherDTO.Info> update(@PathVariable Long id,@RequestBody Object request) {
		((LinkedHashMap) request).remove("attachPic");
		((LinkedHashMap) request).remove("categoryList");
		((LinkedHashMap) request).remove("categories");
		TeacherDTO.Update update = (new ModelMapper()).map(request, TeacherDTO.Update.class);
        return new ResponseEntity<>(teacherService.update(id, update), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
	@PreAuthorize("hasAuthority('d_teacher')")
	public ResponseEntity<Boolean> delete(@PathVariable Long id) {
	try {
		final Optional<Teacher> cById = teacherDAO.findById(id);
		final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
		if (teacher.getAttachPhoto() != null && teacher.getAttachPhoto() != "") {
			File file1 = new File(teacherUploadDir + "/" + teacher.getAttachPhoto());
			file1.delete();
		}
		teacherService.delete(id);
		return new ResponseEntity(true, HttpStatus.OK);
	}
	catch(Exception ex){
		return new ResponseEntity(false, HttpStatus.NO_CONTENT);
	}
	}

	@Loggable
	@DeleteMapping(value = "/list")
	@PreAuthorize("hasAuthority('d_teacher')")
	public ResponseEntity<Void> delete(@Validated @RequestBody TeacherDTO.Delete request) {
		teacherService.delete(request);
		return new ResponseEntity(HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = "/spec-list")
	@PreAuthorize("hasAuthority('r_teacher')")
	public ResponseEntity<TeacherDTO.TeacherSpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
		SearchDTO.SearchRq request = new SearchDTO.SearchRq();
		request.setStartIndex(startRow)
				.setCount(endRow - startRow);

		SearchDTO.SearchRs<TeacherDTO.Info> response = teacherService.search(request);

		final TeacherDTO.SpecRs specResponse = new TeacherDTO.SpecRs();
		specResponse.setData(response.getList())
				.setStartRow(startRow)
				.setEndRow(startRow + response.getTotalCount().intValue())
				.setTotalRows(response.getTotalCount().intValue());

		final TeacherDTO.TeacherSpecRs specRs = new TeacherDTO.TeacherSpecRs();
		specRs.setResponse(specResponse);

		return new ResponseEntity<>(specRs, HttpStatus.OK);
	}

	// ---------------

	@Loggable
	@PostMapping(value = "/search")
	@PreAuthorize("hasAuthority('r_teacher')")
	public ResponseEntity<SearchDTO.SearchRs<TeacherDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
		return new ResponseEntity<>(teacherService.search(request), HttpStatus.OK);
	}

	@Loggable
	@GetMapping(value = {"/print/{type}"})
	public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
		Map<String, Object> params = new HashMap<>();
		params.put(ConstantVARs.REPORT_TYPE, type);
		reportUtil.export("/reports/Teacher.jasper", params, response);
	}

	@Loggable
    @PostMapping(value = "/addCategories/{teacherId}")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity<Void> addCategories(@Validated @RequestBody CategoryDTO.Delete request, @PathVariable Long teacherId) {
        teacherService.addCategories(request,teacherId);
        return new ResponseEntity(HttpStatus.OK);
    }


	@Loggable
	@Transactional
    @PostMapping(value = "/addAttach/{Id}")
    public ResponseEntity<String> addAttach(@RequestParam("file") MultipartFile file, @PathVariable Long Id) {
        FileInfo fileInfo = new FileInfo();
        File destinationFile = null;
        String changedFileName="";
        try {
            if (!file.isEmpty()) {
                    final Optional<Teacher> cById = teacherDAO.findById(Id);
        			final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
        			if(teacher.getAttachPhoto()!=null && teacher.getAttachPhoto()!=""){
        					File file1 = new File(teacherUploadDir + "/" + teacher.getAttachPhoto());
							file1.delete();
					}
        			String currentDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
//        			changedFileName = file.getOriginalFilename().replace(file.getOriginalFilename(), Id.toString() + "_" +currentDate + "." + FilenameUtils.getExtension(file.getOriginalFilename())).toUpperCase();
        			changedFileName = Id.toString() + "_" + currentDate + "_" +  file.getOriginalFilename();
        			destinationFile = new File(teacherUploadDir + File.separator + changedFileName);
        			file.transferTo(destinationFile);
        			fileInfo.setFileName(destinationFile.getPath());
        			fileInfo.setFileSize(file.getSize());
        			teacher.setAttachPhoto(changedFileName);
                     }
                     else
                     	return new ResponseEntity<>(changedFileName,HttpStatus.NO_CONTENT);

        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(changedFileName,HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(changedFileName,HttpStatus.OK);
    }

    @RequestMapping(value = {"/getAttach/{fileName}/{Id}"}, method = RequestMethod.GET)
    public ResponseEntity<InputStreamResource> getAttach(@PathVariable String fileName, ModelMap modelMap, @PathVariable Long Id) {
        try {
            final Optional<Teacher> cById = teacherDAO.findById(Id);
            final Teacher teacher = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TeacherNotFound));
            String attachFileName = teacher.getAttachPhoto();
            if(attachFileName == null || attachFileName == "") {
                return null;
            }
            else {
                File file = new File(teacherUploadDir + fileName);
               	return new ResponseEntity<>(new InputStreamResource(new FileInputStream(file)),HttpStatus.OK);
            }
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }


	@Loggable
	@Transactional
    @PostMapping(value = "/addTempAttach")
    public ResponseEntity<String> addTempAttach(@RequestParam("file") MultipartFile file) throws IOException {
        FileInfo fileInfo = new FileInfo();
        File destinationFile = null;
        String changedFileName="";
        String fileName="";
        double fileSize = file.getSize()/1000.0;

        String[] tempFiles = new File(tempUploadDir).list();
		for (String tempFile : tempFiles) {
			File file1 = new File(tempUploadDir + "/" + tempFile);
			file1.delete();
		}

        try {
            if (!file.isEmpty() && fileSize < 1000.0 && fileSize > 5.0) {
                destinationFile = new File(tempUploadDir + File.separator + file.getOriginalFilename());
                changedFileName = file.getOriginalFilename().replace(file.getOriginalFilename(), "." + FilenameUtils.getExtension(file.getOriginalFilename())).toUpperCase();
                file.transferTo(destinationFile);
                fileInfo.setFileName(destinationFile.getPath());
                fileInfo.setFileSize(file.getSize());
                fileName = file.getOriginalFilename();

                BufferedImage readImage = null;
                readImage = ImageIO.read(new File(tempUploadDir + "/" +file.getOriginalFilename()));
                int h = readImage.getHeight();
                int w = readImage.getWidth();
                if(200>h || h>400 || 100>w || w>300) {
                        return new ResponseEntity<>(fileName,HttpStatus.NO_CONTENT);
                    }
                }
                     else
                     	return new ResponseEntity<>(fileName,HttpStatus.NO_CONTENT);

        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(fileName,HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(fileName,HttpStatus.OK);
    }

    @RequestMapping(value = {"/getTempAttach/{fileName}"}, method = RequestMethod.GET)
    public ResponseEntity<InputStreamResource> getAttach(ModelMap modelMap,@PathVariable String fileName) {
	    File file = new File(tempUploadDir + "/" + fileName);
		try {
			return new ResponseEntity<>(new InputStreamResource(new FileInputStream(file)),HttpStatus.OK);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return null;
		}



	}







}
