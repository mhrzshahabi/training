package com.nicico.training.controller;

import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.file.FileInfo;
import com.nicico.copper.core.util.file.FileUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.ITeacherService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.apache.commons.io.FilenameUtils;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.ui.ModelMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.core.env.Environment;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacher")
public class TeacherRestController {

	private final ITeacherService teacherService;
	private final ReportUtil reportUtil;

    @Value("${nicico.teacher.upload.dir}")
    private String teacherUploadDir;

    private final RepositoryService repositoryService;
    private final FileUtil fileUtil;

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
		TeacherDTO.Update update = (new ModelMapper()).map(request, TeacherDTO.Update.class);
        return new ResponseEntity<>(teacherService.update(id, update), HttpStatus.OK);
	}

	@Loggable
	@DeleteMapping(value = "/{id}")
	@PreAuthorize("hasAuthority('d_teacher')")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		teacherService.delete(id);
		return new ResponseEntity(HttpStatus.OK);
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
    @PostMapping(value = "/addAttach/{Id}")
    public ResponseEntity<Void> addAttach(@RequestParam("file") MultipartFile file, @PathVariable Long Id) {
        File uploadedFile = null;

        if (!file.isEmpty()) {
            String fileName = file.getOriginalFilename();
            try {
                if (!fileName.substring(fileName.lastIndexOf('.')).equalsIgnoreCase(".png"))
                    return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
                uploadedFile = fileUtil.upload(file, teacherUploadDir);
                repositoryService.createDeployment().addInputStream(uploadedFile.getName(), new FileInputStream(uploadedFile)).deploy();
                uploadedFile.delete();
                return new ResponseEntity<>(HttpStatus.OK);
            } catch (Exception e) {
                uploadedFile.delete();
                return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } else {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
    }


}
