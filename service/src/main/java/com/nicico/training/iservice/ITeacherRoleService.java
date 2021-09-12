package com.nicico.training.iservice;

import com.nicico.training.model.Role;

import java.util.List;
import java.util.Map;

public interface ITeacherRoleService {

    List<String> findAllRoleByNationalCode(String nationalCode);

    List<Role> findAllRoleByTeacherId(Long teacherId);

    boolean addRoleByNationalCode(String nationalCode, Long roleId);

    boolean addRoleByNationalCode(String nationalCode, String roleName);

    boolean addRoleByTeacherId(Long teacherId, Long roleId);

    boolean removeTeacherRole(String nationalCode, Long roleId);

    boolean removeTeacherRoleByTeacherId(Long teacherId, Long roleId);

}
