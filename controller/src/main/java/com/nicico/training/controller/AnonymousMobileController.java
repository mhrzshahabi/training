package com.nicico.training.controller;

import com.nicico.training.dto.UserDetailDTO;
import com.nicico.training.iservice.IMobileVerifyService;
import com.nicico.training.model.MobileVerify;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/anonymous-mobile")
public class AnonymousMobileController {
    private final IMobileVerifyService iMobileVerifyService;


    @PostMapping("/add/")
    public ResponseEntity<MobileVerify> addIfNotPresentAnonymousNumber(@RequestParam String nationalCode, @RequestParam String number) {
        return ResponseEntity.ok(iMobileVerifyService.add(nationalCode, number));
    }

    @DeleteMapping("/remove/")
    public ResponseEntity<Boolean> removeAnonymousNumber(@RequestParam String nationalCode, @RequestParam String number) {
        return ResponseEntity.ok(iMobileVerifyService.remove(nationalCode, number));
    }

    @PutMapping("/change/status")
    public ResponseEntity<Boolean> changeAnonymousNumberStatus(@RequestParam String nationalCode, @RequestParam String number,@RequestParam boolean status) {
        return ResponseEntity.ok(iMobileVerifyService.changeStatus(nationalCode, number,status));
    }

    @GetMapping("/status/")
    public ResponseEntity<Boolean> mobileNumberVerifyStatus(@RequestParam String nationalCode, @RequestParam String number) {
        return ResponseEntity.ok(iMobileVerifyService.checkVerificationIfNotPresentAdd(nationalCode, number));
    }

    @GetMapping("/detail/")
    public ResponseEntity<UserDetailDTO> mobileVerifyUserDetail(@RequestParam String nationalCode) {
        return ResponseEntity.ok(iMobileVerifyService.findDetailByNationalCode(nationalCode));
    }
}
