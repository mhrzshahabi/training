package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.iservice.IContactInfoService;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.PersonnelRegistered;
import com.nicico.training.model.Student;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/contactInfo")
public class ContactInfoRestController {

    private final IContactInfoService contactInfoService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<ContactInfoDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(contactInfoService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<List<ContactInfoDTO.Info>> list() {
        return new ResponseEntity<>(contactInfoService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_address')")
    public ResponseEntity create(@Validated @RequestBody ContactInfoDTO.Create request) {
        try {
            return new ResponseEntity<>(contactInfoService.create(request), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PostMapping(value = "/createNewFor/{id}")
//    @PreAuthorize("hasAuthority('c_address')")
    public ResponseEntity createNewFor(@PathVariable Long id, @RequestBody String type) {
        try {
            return new ResponseEntity<>(contactInfoService.createNewFor(id, type), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_address')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody ContactInfoDTO.Update request) {
        try {
            return new ResponseEntity<>(contactInfoService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_address')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            contactInfoService.delete(id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_address')")
    public ResponseEntity<Void> delete(@Validated @RequestBody ContactInfoDTO.Delete request) {
        contactInfoService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<ContactInfoDTO.ContactInfoSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                 @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                 @RequestParam(value = "operator", required = false) String operator,
                                                                 @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<ContactInfoDTO.Info> response = contactInfoService.search(request);

        final ContactInfoDTO.SpecRs specResponse = new ContactInfoDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final ContactInfoDTO.ContactInfoSpecRs specRs = new ContactInfoDTO.ContactInfoSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<SearchDTO.SearchRs<ContactInfoDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(contactInfoService.search(request), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/nationalCodeOfMobile/{mobile}")
    public List<String> nationalCodeOfMobile(@PathVariable String mobile) {
        Map<String, Object> map = contactInfoService.nationalCodeOfMobile(mobile);
        List<String> list = new ArrayList<>();
        for (String nc : map.keySet()) {
            Object already = map.get(nc);
            if (already instanceof Student) {
                list.add(((Student) already).getNationalCode());
            } else if (already instanceof Personnel) {
                list.add(((Personnel) already).getNationalCode());
            } else if (already instanceof PersonnelRegistered) {
                list.add(((PersonnelRegistered) already).getNationalCode());
            }
        }
        return list;
    }

}
