package com.nicico.training.repository;

import com.nicico.training.model.CheckList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CheckListDAO extends JpaRepository<CheckList, Long>, JpaSpecificationExecutor<CheckList> {


}
