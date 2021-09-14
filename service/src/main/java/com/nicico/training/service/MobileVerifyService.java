package com.nicico.training.service;

import com.nicico.training.iservice.IMobileVerifyService;
import com.nicico.training.model.MobileVerify;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.MobileVerifyDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.springframework.stereotype.Service;

import javax.validation.constraints.NotBlank;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MobileVerifyService implements IMobileVerifyService {

    private final MobileVerifyDAO mobileVerifyDAO;
    private final TeacherDAO teacherDAO;

    @Override
    public boolean add(@NotBlank @NotBlank @Length(max = 10) String nationalCode,@NotBlank @NotBlank @Length(max = 11) String number) {
        MobileVerify mobileVerify = new MobileVerify();
        mobileVerify.setNationalCode(nationalCode);
        mobileVerify.setMobileNumber(number);
        Optional<Teacher> teacherCode = teacherDAO.findByTeacherCode(nationalCode);
        if (teacherCode.isPresent() && teacherCode.get().getPersonality()!=null){
                mobileVerify.setName(teacherCode.get().getPersonality().getFirstNameFa());
                mobileVerify.setFamily(teacherCode.get().getPersonality().getLastNameFa());
        }else if ()


        return false;
    }

    @Override
    public boolean remove(@NotBlank @NotBlank @Length(max = 10) String nationalCode,@NotBlank @NotBlank @Length(max = 11) String number) {
        return false;
    }

    @Override
    public boolean checkVerification(@NotBlank @NotBlank @Length(max = 10) String nationalCode,@NotBlank @NotBlank @Length(max = 11) String number) {
        return false;
    }
}
