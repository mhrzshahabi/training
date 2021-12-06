package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AddressDTO;
import com.nicico.training.dto.ContactInfoDTO;
import com.nicico.training.iservice.IAddressService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/address")
public class AddressRestController {

    private final IAddressService addressService;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<AddressDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(addressService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<List<AddressDTO.Info>> list() {
        return new ResponseEntity<>(addressService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_address')")
    public ResponseEntity<AddressDTO.Info> create(@Validated @RequestBody AddressDTO.Create request) {
        return new ResponseEntity<>(addressService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_address')")
    public ResponseEntity<AddressDTO.Info> update(@PathVariable Long id, @Validated @RequestBody AddressDTO.Update request) {
        return new ResponseEntity<>(addressService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_address')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        addressService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_address')")
    public ResponseEntity<Void> delete(@Validated @RequestBody AddressDTO.Delete request) {
        addressService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<AddressDTO.AddressSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                         @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<AddressDTO.Info> response = addressService.search(request);

        final AddressDTO.SpecRs specResponse = new AddressDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final AddressDTO.AddressSpecRs specRs = new AddressDTO.AddressSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_address')")
    public ResponseEntity<SearchDTO.SearchRs<AddressDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(addressService.search(request), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getOneByPostalCode/{postalCode}")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<AddressDTO.Info> getOneByPostalCode(@PathVariable String postalCode) {
        if (postalCode == null || postalCode.equals("undefined"))
            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
        return new ResponseEntity<>(addressService.getOneByPostalCode(postalCode), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getByPostalCodeWithContact/{postalCode}")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<ContactInfoDTO.Info> getByPostalCodeWithContact(@PathVariable String postalCode) {
        if (postalCode == null || postalCode.equals("undefined"))
            return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);
        return new ResponseEntity<>(addressService.getByPostalCodeWithContact(postalCode), HttpStatus.OK);
    }
}
