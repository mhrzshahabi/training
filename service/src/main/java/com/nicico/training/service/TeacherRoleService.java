package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.iservice.ITeacherRoleService;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.Role;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TeacherRole;
import com.nicico.training.repository.PersonalInfoDAO;
import com.nicico.training.repository.RoleDAO;
import com.nicico.training.repository.TeacherDAO;
import com.nicico.training.repository.TeachersRoleDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TeacherRoleService implements ITeacherRoleService {

    private final TeachersRoleDAO teachersRoleDAO;
    private final TeacherDAO teacherDAO;
    private final PersonalInfoDAO personalInfoDAO;
    private final RoleDAO roleDAO;

    @Override
    public List<String> findAllRoleByNationalCode(String nationalCode) {
        List<String> roles = new ArrayList<>();
        List<Map<String, Object>> allTeacherRoleByNationalCode = teacherDAO.findAllTeacherRoleByNationalCode(nationalCode);
        if (!allTeacherRoleByNationalCode.isEmpty()) {
            for (Map<String, Object> objectMap : allTeacherRoleByNationalCode) {
                roles.add(objectMap.get("name").toString());
            }
        }
        return roles;
    }

    @Override
    public List<Role> findAllRoleByTeacherId(Long teacherId) {
        Teacher teacher = teacherDAO.findById(teacherId).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        List<TeacherRole> allByTeacher = teachersRoleDAO.findAllByTeacher(teacher);
        if (!allByTeacher.isEmpty())
            return allByTeacher.stream().map(TeacherRole::getRole).collect(Collectors.toList());
        else
            return Collections.emptyList();
    }

    @Override
    public boolean addRoleByNationalCode(String nationalCode, String roleName) {
        PersonalInfo personalInfo = personalInfoDAO.findByNationalCode(nationalCode).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        Teacher teacher = teacherDAO.findByPersonality(personalInfo).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        Role role = roleDAO.findByName(roleName).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        TeacherRole teacherRole = new TeacherRole();
        teacherRole.setTeacher(teacher);
        teacherRole.setRole(role);
        teachersRoleDAO.save(teacherRole);
        return true;
    }

    @Override
    @Transactional
    public boolean addRoleByNationalCode(String nationalCode, Long roleId) {
        PersonalInfo personalInfo = personalInfoDAO.findByNationalCode(nationalCode).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        Teacher teacher = teacherDAO.findByPersonality(personalInfo).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        Role role = roleDAO.findById(roleId).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        TeacherRole teacherRole = new TeacherRole();
        teacherRole.setTeacher(teacher);
        teacherRole.setRole(role);
        teachersRoleDAO.save(teacherRole);
        return true;
    }

    @Override
    public boolean addRoleByTeacherId(Long teacherId, Long roleId) {
        Teacher teacher = teacherDAO.findById(teacherId).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        Role role = roleDAO.findById(roleId).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        TeacherRole teacherRole = new TeacherRole();
        teacherRole.setTeacher(teacher);
        teacherRole.setRole(role);
        teachersRoleDAO.save(teacherRole);
        return true;
    }

    @Override
    public boolean removeTeacherRole(String nationalCode, Long roleId) {
        PersonalInfo personalInfo = personalInfoDAO.findByNationalCode(nationalCode).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        Teacher teacher = teacherDAO.findByPersonality(personalInfo).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        Role role = roleDAO.findById(roleId).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );

        TeacherRole teacherRole = teachersRoleDAO.findByTeacherAndRole(teacher, role).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        teachersRoleDAO.delete(teacherRole);
        return true;
    }


    @Override
    public boolean removeTeacherRoleByTeacherId(Long teacherId, Long roleId) {
        Teacher teacher = teacherDAO.findById(teacherId).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        Role role = roleDAO.findById(roleId).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );

        TeacherRole teacherRole = teachersRoleDAO.findByTeacherAndRole(teacher, role).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        teachersRoleDAO.delete(teacherRole);
        return true;
    }
}
