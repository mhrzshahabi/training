package com.nicico.training.iservice;

import com.nicico.training.model.Role;
import com.nicico.training.model.TeacherRole;

import java.util.List;

public interface ITeacherRoleService {

    List<String> findAllTeacherRoleByNationalCode(String nationalCode);

    List<Role> findAllRoleByTeacherId(Long teacherId);

    List<TeacherRole> findAllTeacherRoleByTeacherId(Long teacherId);

    boolean addRoleByNationalCode(String nationalCode, Long roleId);

    boolean addRoleByNationalCode(String nationalCode, String roleName);

    boolean addRoleByTeacherId(Long teacherId, Long roleId);

    boolean addRolesByTeacherId(Long teacherId, List<String> roleNames);

    boolean addRoleByTeacherId(Long teacherId, String roleName);

    boolean removeTeacherRole(String nationalCode, Long roleId);

    boolean removeRolesByTeacherId(Long teacherId, List<String> roleNames);

    boolean removeTeacherRole(String nationalCode, String roleName);

    boolean removeTeacherRole(Long teacherId, String roleName);

    boolean removeTeacherRoleByTeacherId(Long teacherId, Long roleId);

    boolean removeTeacherRolesById(Long teacherRoleId);

}
