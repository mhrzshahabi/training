package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.util.file.FileInfo;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonalInfoDTO;
import com.nicico.training.iservice.IPersonalInfoService;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.repository.PersonalInfoDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/personalInfo")
public class PersonalInfoRestController {

    private final IPersonalInfoService personalInfoService;
    private final PersonalInfoDAO personalInfoDAO;

    @Value("${nicico.dirs.upload-person-img}")
    private String personUploadDir;

    @Value("${nicico.dirs.upload-person-tmp}")
    private String tempUploadDir;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<PersonalInfoDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(personalInfoService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getOneByNationalCode/{nationalCode}")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<PersonalInfoDTO.Info> getOneByNationalCode(@PathVariable String nationalCode) {
        return new ResponseEntity<>(personalInfoService.getOneByNationalCode(nationalCode), HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<List<PersonalInfoDTO.Info>> list() {
        return new ResponseEntity<>(personalInfoService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_personalInfo')")
    public ResponseEntity create(@Validated @RequestBody PersonalInfoDTO.Create request) {
        try {
            return new ResponseEntity<>(personalInfoService.create(request), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_personalInfo')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody PersonalInfoDTO.Update request) {
        try {
            return new ResponseEntity<>(personalInfoService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_personalInfo')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            personalInfoService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_personalInfo')")
    public ResponseEntity<Void> delete(@Validated @RequestBody PersonalInfoDTO.Delete request) {
        personalInfoService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<PersonalInfoDTO.PersonalInfoSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                   @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                   @RequestParam(value = "operator", required = false) String operator,
                                                                   @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<PersonalInfoDTO.Info> response = personalInfoService.search(request);

        final PersonalInfoDTO.SpecRs specResponse = new PersonalInfoDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final PersonalInfoDTO.PersonalInfoSpecRs specRs = new PersonalInfoDTO.PersonalInfoSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<SearchDTO.SearchRs<PersonalInfoDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(personalInfoService.search(request), HttpStatus.OK);
    }

    @RequestMapping(value = {"/getAttach/{Id}"}, method = RequestMethod.GET)
    @Transactional
    public ResponseEntity<InputStreamResource> getAttach(ModelMap modelMap, @PathVariable Long Id) {
        final Optional<PersonalInfo> cById = personalInfoDAO.findById(Id);
        final PersonalInfo personalInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        String fileName = personalInfo.getPhoto();
        File file = new File(personUploadDir + "/" + fileName);
        try {
            return new ResponseEntity<>(new InputStreamResource(new FileInputStream(file)), HttpStatus.OK);

        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        }

    }

    @RequestMapping(value = {"/checkAttach/{Id}"}, method = RequestMethod.GET)
    @Transactional
    public ResponseEntity<Boolean> checkAttach(@PathVariable Long Id) {
        final Optional<PersonalInfo> cById = personalInfoDAO.findById(Id);
        final PersonalInfo personalInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        String fileName = personalInfo.getPhoto();
        try {
            if (fileName == null || fileName.equalsIgnoreCase("") || fileName.equalsIgnoreCase("null"))
                return new ResponseEntity<>(false, HttpStatus.OK);
            else
                return new ResponseEntity<>(true, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping(value = {"/getTempAttach/{fileName}"}, method = RequestMethod.GET)
    public ResponseEntity<InputStreamResource> getTempAttach(ModelMap modelMap, @PathVariable String fileName) {
        File file = new File(tempUploadDir + "/" + fileName);
        try {
            return new ResponseEntity<>(new InputStreamResource(new FileInputStream(file)), HttpStatus.OK);

        } catch (FileNotFoundException e) {
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
        String changedFileName = "";
        String fileName = "";
        double fileSize = file.getSize() / 1000.0;

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
                readImage = ImageIO.read(new File(tempUploadDir + "/" + file.getOriginalFilename()));
                int h = readImage.getHeight();
                int w = readImage.getWidth();
                if (100 > h || h > 500 || 100 > w || w > 500) {
                    return new ResponseEntity<>("wrong dimension", HttpStatus.NOT_ACCEPTABLE);
                }
            } else
                return new ResponseEntity<>("wrong size", HttpStatus.NOT_ACCEPTABLE);

        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(fileName, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(fileName, HttpStatus.OK);
    }

    @Loggable
    @Transactional
    @PostMapping(value = "/addAttach/{Id}")
    public ResponseEntity<String> addAttach(@RequestParam("file") MultipartFile file, @PathVariable Long Id) {
        FileInfo fileInfo = new FileInfo();
        File destinationFile = null;
        String changedFileName = "";
        try {
            if (!file.isEmpty()) {
                final Optional<PersonalInfo> cById = personalInfoDAO.findById(Id);
                final PersonalInfo personalInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                if (personalInfo.getPhoto() != null && personalInfo.getPhoto() != "") {
                    File file1 = new File(personUploadDir + "/" + personalInfo.getPhoto());
                    file1.delete();
                }
                String currentDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
                changedFileName = Id.toString() + "_" + currentDate + "_" + file.getOriginalFilename();
                destinationFile = new File(personUploadDir + File.separator + changedFileName);
                file.transferTo(destinationFile);
                fileInfo.setFileName(destinationFile.getPath());
                fileInfo.setFileSize(file.getSize());
                personalInfo.setPhoto(changedFileName);
            } else
                return new ResponseEntity<>(changedFileName, HttpStatus.NO_CONTENT);

        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(changedFileName, HttpStatus.INTERNAL_SERVER_ERROR);
        }
        return new ResponseEntity<>(changedFileName, HttpStatus.OK);
    }


}
