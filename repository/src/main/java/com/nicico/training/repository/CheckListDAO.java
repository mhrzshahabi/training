package com.nicico.training.repository;

import com.nicico.training.model.CheckList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CheckListDAO extends JpaRepository<CheckList, Long>, JpaSpecificationExecutor<CheckList> {
}
