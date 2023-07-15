package com.nicico.training.repository;

import com.nicico.training.model.FeeItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FeeItemDAO extends JpaRepository<FeeItem, Long>, JpaSpecificationExecutor<FeeItem> {

    List<FeeItem> findAllByClassId(Long classId);

    List<FeeItem> findAllByClassFeeId(Long classFeeId);

}