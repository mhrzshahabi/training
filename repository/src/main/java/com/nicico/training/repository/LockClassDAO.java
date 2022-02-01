package com.nicico.training.repository;

import com.nicico.training.model.LockClass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface LockClassDAO extends JpaRepository<LockClass, Long>, JpaSpecificationExecutor<LockClass> {

    Optional<LockClass> findByClassId(Long id);
}
