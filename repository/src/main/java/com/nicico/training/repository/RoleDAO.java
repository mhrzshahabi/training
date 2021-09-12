package com.nicico.training.repository;

import com.nicico.training.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleDAO extends JpaRepository<Role, Long> {

    Optional<Role> findByName(String name);
}
