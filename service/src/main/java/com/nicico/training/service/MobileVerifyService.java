package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.iservice.IMobileVerifyService;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.model.MobileVerify;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.MobileVerifyDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.constraints.NotBlank;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MobileVerifyService implements IMobileVerifyService {

    private final MobileVerifyDAO mobileVerifyDAO;
    private final TeacherDAO teacherDAO;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;

    @Override
    @Transactional
    public boolean add(@NotBlank @NotBlank @Length(max = 10) String nationalCode, @NotBlank @NotBlank @Length(max = 11) String number) {
        MobileVerify mobileVerify = new MobileVerify();
        mobileVerify.setNationalCode(nationalCode);
        mobileVerify.setMobileNumber(number);
        Optional<Teacher> teacherCode = teacherDAO.findByTeacherCode(nationalCode);
        if (teacherCode.isPresent() && teacherCode.get().getPersonality() != null) {
            mobileVerify.setName(teacherCode.get().getPersonality().getFirstNameFa());
            mobileVerify.setFamily(teacherCode.get().getPersonality().getLastNameFa());
            mobileVerifyDAO.save(mobileVerify);
            return true;
        }
        PersonnelDTO.PersonalityInfo byNationalCode = personnelService.getByNationalCode(nationalCode);
        if (byNationalCode != null) {
            mobileVerify.setName(byNationalCode.getFirstName());
            mobileVerify.setFamily(byNationalCode.getLastName());
            mobileVerifyDAO.save(mobileVerify);
            return true;
        }
        PersonnelRegisteredDTO.Info oneByNationalCode = personnelRegisteredService.getOneByNationalCode(nationalCode);
        if (oneByNationalCode != null) {
            mobileVerify.setName(oneByNationalCode.getFirstName());
            mobileVerify.setFamily(oneByNationalCode.getLastName());
            mobileVerifyDAO.save(mobileVerify);
            return true;
        }
        mobileVerifyDAO.save(mobileVerify);
        return true;
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
    public boolean checkVerification(@NotBlank @NotBlank @Length(max = 10) String nationalCode, @NotBlank @NotBlank @Length(max = 11) String number) {
        MobileVerify mobileVerify = mobileVerifyDAO.findByNationalCodeAndMobileNumber(nationalCode, number).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.NotFound)
        );
        return mobileVerify.isVerify();
    }

    @Override
    @Transactional
    public boolean changeStatus(String nationalCode, String number, boolean status) {
        MobileVerify mobileVerify = mobileVerifyDAO.findByNationalCodeAndMobileNumber(nationalCode, number).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.NotFound)
        );
        mobileVerify.setVerify(status);
        mobileVerifyDAO.save(mobileVerify);
        return true;
    }
}
