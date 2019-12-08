package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttachmentDTO;
import com.nicico.training.iservice.IAttachmentService;
import com.sun.deploy.net.URLEncoder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/attachment")
public class AttachmentRestController {

    private final IAttachmentService attachmentService;

    @Value("${nicico.upload.dir}")
    private String uploadDir;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<AttachmentDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(attachmentService.get(id), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList/{objectType},{objectId}")
    public ResponseEntity<ISC<AttachmentDTO.Info>> iscList(HttpServletRequest iscRq,
                                                           @PathVariable(required = false) String objectType,
                                                           @PathVariable(required = false) Long objectId) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        objectType = "".equals(objectType) ? null : objectType;
        SearchDTO.SearchRs<AttachmentDTO.Info> searchRs = attachmentService.search(searchRq, objectType, objectId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_address')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody AttachmentDTO.Update request) {
        try {
            return new ResponseEntity<>(attachmentService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_address')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            attachmentService.delete(id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_address')")
    public ResponseEntity delete(@Validated @RequestBody AttachmentDTO.Delete request) {
        attachmentService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @Transactional
    @PostMapping(value = "/upload")
    public ResponseEntity upload(@RequestParam("file") MultipartFile file,
                                 @RequestParam("objectType") String objectType,
                                 @RequestParam("objectId") Long objectId,
                                 @RequestParam("fileName") String fileName,
                                 @RequestParam("fileTypeId") Long fileTypeId,
                                 @RequestParam("description") String description) {
        if (file.isEmpty())
            return new ResponseEntity<>("wrong size", HttpStatus.NOT_ACCEPTABLE);
        AttachmentDTO.Create request = new AttachmentDTO.Create();
        request.setObjectType(objectType);
        request.setObjectId(objectId);
        request.setFileName(fileName);
        request.setFileTypeId(fileTypeId);
        if (description != null && !description.equals("undefined") && !description.equals("null"))
            request.setDescription(description);
        try {
            AttachmentDTO.Info attachment = attachmentService.create(request);
            String fileFullPath = uploadDir + File.separator + attachment.getObjectType() + File.separator + attachment.getId();
            File destinationFile = new File(fileFullPath);
            file.getOriginalFilename().replace(file.getOriginalFilename(), attachment.getId().toString());
            file.transferTo(destinationFile);
            return new ResponseEntity<>(fileName, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping(value = {"/download/{Id}"}, method = RequestMethod.GET)
    @Transactional
    public void getAttach(HttpServletRequest request, HttpServletResponse response, @PathVariable Long Id) {
        AttachmentDTO.Info attachment = attachmentService.get(Id);
        String fileFullPath = uploadDir + File.separator + attachment.getObjectType() + File.separator + attachment.getId();
        try {
            File file = new File(fileFullPath);
            FileInputStream inputStream = new FileInputStream(file);
            String mimeType = new MimetypesFileTypeMap().getContentType(fileFullPath);
            String fileName = URLEncoder.encode(attachment.getFileName(), "UTF-8").replace("+", "%20");
            if (mimeType == null) {
                mimeType = "application/octet-stream";
            }
            String headerKey = "Content-Disposition";
            String headerValue;
            if (fileName.contains(".pdf")) {
                response.setContentType("application/pdf");
                headerValue = String.format("filename=\"%s\"", fileName);
            } else {
                response.setContentType(mimeType);
                headerValue = String.format("attachment; filename=\"%s\"", fileName);
            }
            response.setHeader(headerKey, headerValue);
            response.setContentLength((int) file.length());
            OutputStream outputStream = response.getOutputStream();
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            outputStream.flush();
            inputStream.close();

        } catch (FileNotFoundException e) {
            String headerKey = "Content-Disposition";
            String headerValue = String.format("attachment; filename=\"%s\"", "NOT_FOUND");
            response.setHeader(headerKey, headerValue);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<SearchDTO.SearchRs<AttachmentDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(attachmentService.search(request, null, null), HttpStatus.OK);
    }

}
