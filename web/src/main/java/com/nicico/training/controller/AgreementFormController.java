package com.nicico.training.controller;

import com.nicico.training.controller.utility.WordUtil;
import com.nicico.training.dto.AgreementDTO;
import com.nicico.training.iservice.IAgreementService;
import com.nicico.training.mapper.agreement.AgreementBeanMapper;
import com.nicico.training.model.Agreement;
import com.nicico.training.utility.persianDate.PersianDate;
import lombok.RequiredArgsConstructor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import response.BaseResponse;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;

@RequiredArgsConstructor
@Controller
@RequestMapping("/agreement")
public class AgreementFormController {

    private final WordUtil wordUtil;
    private final IAgreementService agreementService;
    private final AgreementBeanMapper agreementBeanMapper;

    @GetMapping(value = {"/print/{agreementId}"})
    public void printDocx(HttpServletResponse response, @PathVariable Long agreementId, @RequestParam("finalCostChars") String finalCostChars) throws IOException {

        BaseResponse baseResponse = new BaseResponse();
        Agreement agreement = agreementService.get(agreementId);

        if (agreement == null) {

            baseResponse.setStatus(HttpStatus.NOT_FOUND.value());
            baseResponse.setMessage("یافت نشد");
        } else {

            String todayDate = PersianDate.now().toString();
            AgreementDTO.PrintInfo agreementDTO = agreementBeanMapper.toAgreementPrintInfo(agreement);

            InputStream stream = new ClassPathResource("reports/word/Agreement.docx").getInputStream();
            XWPFDocument doc = new XWPFDocument(stream);

            // replace data
            wordUtil.replacePOI(doc, "TODAY_DATE", todayDate);

            wordUtil.replacePOI(doc, "FIRST_PARTY_NAME", agreementDTO.getFirstParty().get("firstPartyName"));
            wordUtil.replacePOI(doc, "FIRST_PARTY_ECONOMICAL_ID", agreementDTO.getFirstParty().get("firstPartyEconomicalId"));
            wordUtil.replacePOI(doc, "FIRST_PARTY_PHONE", agreementDTO.getFirstParty().get("firstPartyPhone"));
            wordUtil.replacePOI(doc, "FIRST_PARTY_FAX", agreementDTO.getFirstParty().get("firstPartyFax"));

            wordUtil.replacePOI(doc, "TEACHER_NAME", agreementDTO.getSecondPartyTeacher().get("teacherName"));
            wordUtil.replacePOI(doc, "TEACHER_LAST_NAME", agreementDTO.getSecondPartyTeacher().get("teacherLastName"));
            wordUtil.replacePOI(doc, "TEACHER_FATHER_NAME", agreementDTO.getSecondPartyTeacher().get("teacherFatherName"));
            wordUtil.replacePOI(doc, "TEACHER_BIRTH_CERTIFICATE", agreementDTO.getSecondPartyTeacher().get("teacherBirthCertificate"));
            wordUtil.replacePOI(doc, "TEACHER_NATIONAL_CODE", agreementDTO.getSecondPartyTeacher().get("teacherNationalCode"));
            wordUtil.replacePOI(doc, "TEACHER_BIRTH_DATE", agreementDTO.getSecondPartyTeacher().get("teacherBirthDate"));
            wordUtil.replacePOI(doc, "TEACHER_EDUCATION_LEVEL", agreementDTO.getSecondPartyTeacher().get("teacherEducationLevel"));
            wordUtil.replacePOI(doc, "TEACHER_ADDRESS", agreementDTO.getSecondPartyTeacher().get("teacherAddress"));
            wordUtil.replacePOI(doc, "TEACHER_POSTAL_CODE", agreementDTO.getSecondPartyTeacher().get("teacherPostalCode"));
            wordUtil.replacePOI(doc, "TEACHER_MOBILE", agreementDTO.getSecondPartyTeacher().get("teacherMobile"));

            wordUtil.replacePOI(doc, "INSTITUTE_NAME", agreementDTO.getSecondPartyInstitute().get("instituteName"));
            wordUtil.replacePOI(doc, "INSTITUTE_ID", agreementDTO.getSecondPartyInstitute().get("instituteId"));
            wordUtil.replacePOI(doc, "INSTITUTE_ECONOMICAL_ID", agreementDTO.getSecondPartyInstitute().get("instituteEconomicalId"));
            wordUtil.replacePOI(doc, "INSTITUTE_ADDRESS", agreementDTO.getSecondPartyInstitute().get("instituteAddress"));
            wordUtil.replacePOI(doc, "INSTITUTE_PHONE", agreementDTO.getSecondPartyInstitute().get("institutePhone"));
            wordUtil.replacePOI(doc, "INSTITUTE_MANAGER_NAME", agreementDTO.getSecondPartyInstitute().get("instituteManagerName"));
            wordUtil.replacePOI(doc, "INSTITUTE_MANAGER_MOBILE", agreementDTO.getSecondPartyInstitute().get("instituteManagerMobile"));

            wordUtil.replacePOI(doc, "SECOND_PARTY_NAME", agreementDTO.getSecondParty().get("secondPartyName"));
            wordUtil.replacePOI(doc, "SECOND_PARTY_SHABA", agreementDTO.getSecondParty().get("secondPartyShaba"));
            wordUtil.replacePOI(doc, "SECOND_PARTY_BANK", agreementDTO.getSecondParty().get("secondPartyBank"));

            wordUtil.replacePOI(doc, "FINAL_COST", agreementDTO.getFinalCost().toString());
            wordUtil.replacePOI(doc, "CHARS", finalCostChars);
            wordUtil.replacePOI(doc, "CURRENCY", agreementDTO.getCurrency());
            wordUtil.replacePOI(doc, "SUBJECT", agreementDTO.getSubject());


            response.setHeader("Content-Disposition", "attachment; filename=Agreement");
            response.setContentType("application/vnd.ms-word");
            ServletOutputStream out = response.getOutputStream();
            doc.write(out);
            out.flush();
        }
    }

}
