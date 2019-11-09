package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AttachmentDTO;
import com.nicico.training.iservice.IAttachmentService;
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

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.OutputStream;
import java.util.List;

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

    @Loggable
    @GetMapping(value = "/list/{entityName}:{objectId}")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<List<AttachmentDTO.Info>> list(@PathVariable String entityName,
                                                         @PathVariable Long objectId) {
        return new ResponseEntity<>(attachmentService.list(entityName, objectId), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_address')")
    public ResponseEntity create(@Validated @RequestBody AttachmentDTO.Create request) {
        try {
            return new ResponseEntity<>(attachmentService.create(request), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_address')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody AttachmentDTO.Update request) {
        try {
            return new ResponseEntity<>(attachmentService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
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
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    null,
                    HttpStatus.NOT_ACCEPTABLE);
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
    @GetMapping(value = "/spec-list/{entityName}:{objectId}")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<AttachmentDTO.AttachmentSpecRs> list(@RequestParam("_startRow") Integer startRow,
                                                               @RequestParam("_endRow") Integer endRow,
                                                               @PathVariable String entityName,
                                                               @PathVariable Long objectId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);


        List<AttachmentDTO.Info> response = attachmentService.list(entityName, objectId);

        final AttachmentDTO.SpecRs specResponse = new AttachmentDTO.SpecRs();
        specResponse.setData(response)
                .setStartRow(startRow)
                .setEndRow(startRow + response.size())
                .setTotalRows(response.size());

        final AttachmentDTO.AttachmentSpecRs specRs = new AttachmentDTO.AttachmentSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @Transactional
    @PostMapping(value = "/upload")
    public ResponseEntity upload(@RequestParam("file") MultipartFile file,
                                 @RequestParam("entityName") String entityName,
                                 @RequestParam("objectId") Long objectId,
                                 @RequestParam("fileName") String fileName,
                                 @RequestParam("fileType") String fileType,
                                 @RequestParam("description") String description) {
        if (file.isEmpty())
            return new ResponseEntity<>("wrong size", HttpStatus.NOT_ACCEPTABLE);
        AttachmentDTO.Create request = new AttachmentDTO.Create();
        request.setEntityName(entityName);
        request.setObjectId(objectId);
        request.setFileName(fileName);
        request.setFileType(fileType);
        if (description != null && !description.equals("undefined") && !description.equals("null"))
            request.setDescription(description);
        try {
            AttachmentDTO.Info attachment = attachmentService.create(request);
            String fileFullPath = uploadDir + File.separator + attachment.getEntityName() + File.separator + attachment.getId() + "." + attachment.getFileType();
            File destinationFile = new File(fileFullPath);
            file.getOriginalFilename().replace(file.getOriginalFilename(), attachment.getId() + "." + attachment.getFileType());
            file.transferTo(destinationFile);
            return new ResponseEntity<>(fileName + "." + fileType, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), null, HttpStatus.NOT_ACCEPTABLE);
        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping(value = {"/download/{Id}"}, method = RequestMethod.GET)
    @Transactional
    public void getAttach(HttpServletRequest request, HttpServletResponse response, @PathVariable Long Id) {
        AttachmentDTO.Info attachment = attachmentService.get(Id);
        String fileFullPath = uploadDir + File.separator + attachment.getEntityName() + File.separator + attachment.getId() + "." + attachment.getFileType();
        try {
            File file = new File(fileFullPath);
            FileInputStream inputStream = new FileInputStream(file);

            ServletContext context = request.getServletContext();
            String mimeType = context.getMimeType(fileFullPath);
            if (mimeType == null) {
                mimeType = "application/octet-stream";
            }
            response.setContentType(mimeType);

            String headerKey = "Content-Disposition";
            String headerValue = String.format("attachment; filename=\"%s\"", attachment.getFileName() + "." + attachment.getFileType());
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
        return new ResponseEntity<>(attachmentService.search(request), HttpStatus.OK);
    }

}
