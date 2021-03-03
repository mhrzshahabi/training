package com.nicico.training.repository;

import com.nicico.training.model.ClassSession;
import com.nicico.training.model.IClassSessionDTO;
import com.nicico.training.model.LockClass;
import com.nicico.training.model.Tclass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LockClassDAO extends JpaRepository<LockClass, Long>, JpaSpecificationExecutor<LockClass> {

    Optional<LockClass> findByClassId(Long id);

}
