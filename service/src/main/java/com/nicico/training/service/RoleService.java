package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.RoleDTO;
import com.nicico.training.iservice.IRoleService;
import com.nicico.training.model.Role;
import com.nicico.training.repository.RoleDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RoleService implements IRoleService {

    private final RoleDAO roleDAO;

    @Override
    public boolean addRole(String name) {
        Role role = new Role();
        role.setName(name);
        roleDAO.save(role);
        return true;
    }

    @Override
    public boolean removeRole(String name) {
        Role role = roleDAO.findByName(name).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        roleDAO.delete(role);
        return true;
    }

    @Override
    public boolean deleteById(Long id) {
        roleDAO.findById(id).orElseThrow(
                () -> new TrainingException(TrainingException.ErrorType.InvalidData)
        );
        roleDAO.deleteById(id);
        return true;
    }

    @Override
    public List<Role> findAll() {
        return roleDAO.findAll();
    }
}
