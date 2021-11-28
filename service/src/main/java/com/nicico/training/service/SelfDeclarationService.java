package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.ISelfDeclarationService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.mapper.selfdeclaration.SelfDeclarationMapper;
import com.nicico.training.model.SelfDeclaration;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.SelfDeclarationDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SelfDeclarationService implements ISelfDeclarationService {

    private final TeacherDAO teacherDAO;
    private final ITeacherService iTeacherService;
    private final IPersonnelService personnelService;
    private final SelfDeclarationDAO selfDeclarationDAO;
    private final SelfDeclarationMapper selfDeclarationMapper;
    private final IPersonnelRegisteredService personnelRegisteredService;

    @Override
    @Transactional
    public SelfDeclaration create(SelfDeclarationDTO declarationDTO) {
        SelfDeclaration selfDeclaration = selfDeclarationMapper.requestToEntity(declarationDTO);
        return selfDeclarationDAO.save(selfDeclaration);
    }

    @Override
    public boolean remove(String nationalCode, String mobileNumber) {
        SelfDeclaration selfDeclaration = selfDeclarationDAO.findByNationalCodeAndMobileNumber(nationalCode, mobileNumber).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.NotFound)
        );
        selfDeclarationDAO.deleteById(selfDeclaration.getId());
        return true;
    }

    @Override
    public boolean findByNumber(String number) {
        Optional<SelfDeclaration> mobileNumber = selfDeclarationDAO.findByMobileNumber(number);
        return mobileNumber.isPresent();
    }

    @Override
    public List<SelfDeclaration> findByNationalCode(String nationalCode) {
        return selfDeclarationDAO.findAllByNationalCode(nationalCode);
    }

    public UserDetailDTO findDetailByNationalCode(String nationalCode) {
        UserDetailDTO dto = new UserDetailDTO();
        Optional<Teacher> teacherCode = teacherDAO.findByTeacherCode(nationalCode);
        if (teacherCode.isPresent() && teacherCode.get().getPersonality() != null) {
            TeacherDTO.Info teacherDTO = iTeacherService.get(teacherCode.get().getId());
            dto.setName(teacherDTO.getPersonality().getFirstNameFa());
            dto.setFamily(teacherDTO.getPersonality().getLastNameFa());
            dto.setPersonType("TEACHER");
            return dto;
        }
        PersonnelDTO.PersonalityInfo byNationalCode = personnelService.getByNationalCode(nationalCode);
        if (byNationalCode != null) {
            dto.setName(byNationalCode.getFirstName());
            dto.setFamily(byNationalCode.getLastName());
            dto.setPersonType("PERSON");
            return dto;
        }
        PersonnelRegisteredDTO.Info oneByNationalCode = personnelRegisteredService.getOneByNationalCode(nationalCode);
        if (oneByNationalCode != null) {
            dto.setName(oneByNationalCode.getFirstName());
            dto.setFamily(oneByNationalCode.getLastName());
            dto.setPersonType("PERSON_REGISTER");
            return dto;
        }
        return dto;
    }

    @Override
    public List<SelfDeclaration> findAll() {
        return selfDeclarationDAO.findAll();
    }
}
