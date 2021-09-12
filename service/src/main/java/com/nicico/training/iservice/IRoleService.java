package com.nicico.training.iservice;

import com.nicico.training.dto.RoleDTO;
import com.nicico.training.model.Role;

import java.util.List;

public interface IRoleService {

    boolean addRole(String name);

    boolean removeRole(String name);

    boolean deleteById(Long id);

    List<Role> findAll();
}
