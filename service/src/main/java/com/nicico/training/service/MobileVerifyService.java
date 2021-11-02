package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.dto.UserDetailDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.iservice.IMobileVerifyService;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.MobileVerify;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.MobileVerifyDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.constraints.NotBlank;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MobileVerifyService implements IMobileVerifyService {

    private final MobileVerifyDAO mobileVerifyDAO;
    private final TeacherDAO teacherDAO;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final ITeacherService iTeacherService;
    private final IPersonalInfoService personalInfoService;
    private final TeacherService teacherService;

    @Override
    @Transactional
    public MobileVerify add(@NotBlank @NotBlank @Length(max = 10) String nationalCode, @NotBlank @NotBlank @Length(max = 11) String number) {
        Optional<MobileVerify> mobileVerification = mobileVerifyDAO.findByNationalCodeAndMobileNumber(nationalCode, number);
        if (mobileVerification.isPresent())
            return mobileVerification.get();
        MobileVerify mobileVerify = new MobileVerify();
        mobileVerify.setNationalCode(nationalCode);
        mobileVerify.setMobileNumber(number);
        mobileVerify.setVerify(checkMobileWithNationalCodeIsInTraining(nationalCode, number));
        return mobileVerifyDAO.save(mobileVerify);
    }

    private boolean checkMobileWithNationalCodeIsInTraining(@NotBlank @NotBlank @Length(max = 10) String nationalCode, @NotBlank @NotBlank @Length(max = 11) String number) {
        String convertNumber = "%" + Long.parseLong(number);
        if (!iTeacherService.findAllByNationalCodeAndMobileNumber(nationalCode, convertNumber).isEmpty())
            return true;
        if (!personalInfoService.findByNationalCodeAndMobileNumber(nationalCode, convertNumber).isEmpty())
            return true;
        return !personnelRegisteredService.findByNationalCodeAndMobileNumber(nationalCode, convertNumber).isEmpty();
    }

    @Override
    @Transactional
    public boolean remove(@NotBlank @NotBlank @Length(max = 10) String nationalCode, @NotBlank @NotBlank @Length(max = 11) String number) {
        MobileVerify mobileVerify = mobileVerifyDAO.findByNationalCodeAndMobileNumber(nationalCode, number).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.NotFound)
        );
        mobileVerifyDAO.delete(mobileVerify);
        return true;
    }

    @Override
    @Transactional
    public boolean checkVerificationIfNotPresentAdd(@NotBlank @NotBlank @Length(max = 10, min = 10) String nationalCode, @NotBlank @NotBlank @Length(max = 11, min = 11) String number) {
        Optional<MobileVerify> verify = mobileVerifyDAO.findByNationalCodeAndMobileNumber(nationalCode, number);
        return verify.map(MobileVerify::isVerify).orElseGet(() -> add(nationalCode, number).isVerify());
    }

    @Override
    @Transactional
    public boolean changeStatus(@NotBlank @NotBlank @Length(max = 10) String nationalCode, @NotBlank @NotBlank @Length(max = 11) String number, boolean status) {
        MobileVerify mobileVerify = mobileVerifyDAO.findByNationalCodeAndMobileNumber(nationalCode, number).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.NotFound)
        );
        mobileVerify.setVerify(status);
        mobileVerifyDAO.save(mobileVerify);
        return true;
    }

    public UserDetailDTO findDetailByNationalCode(String nationalCode) {
        UserDetailDTO dto = new UserDetailDTO();
        Optional<Teacher> teacherCode = teacherDAO.findByTeacherCode(nationalCode);

        if (teacherCode.isPresent() && teacherCode.get().getPersonality() != null) {
            TeacherDTO.Info teacherDTO = iTeacherService.get(teacherCode.get().getId());
            dto.setName(teacherDTO.getPersonality().getFirstNameFa());
            dto.setFamily(teacherDTO.getPersonality().getLastNameFa());
            dto.setPersonType("TEACHER");
        }
        PersonnelDTO.PersonalityInfo byNationalCode = personnelService.getByNationalCode(nationalCode);
        if (byNationalCode != null) {
            dto.setName(byNationalCode.getFirstName());
            dto.setFamily(byNationalCode.getLastName());
            dto.setPersonType("PERSON");
        }
        PersonnelRegisteredDTO.Info oneByNationalCode = personnelRegisteredService.getOneByNationalCode(nationalCode);
        if (oneByNationalCode != null) {
            dto.setName(oneByNationalCode.getFirstName());
            dto.setFamily(oneByNationalCode.getLastName());
            dto.setPersonType("PERSON_REGISTER");
        }
        return dto;
    }

    @Override
    public List<MobileVerify> findAll() {
        return mobileVerifyDAO.findAll();
    }
}
