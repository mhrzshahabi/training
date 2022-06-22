package com.nicico.training.repository;

import com.nicico.training.model.RequestItemCoursesDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RequestItemCoursesDetailDAO extends JpaRepository<RequestItemCoursesDetail, Long>, JpaSpecificationExecutor<RequestItemCoursesDetail> {

    List<RequestItemCoursesDetail> findAllByRequestItemProcessDetailId(Long requestItemProcessDetailId);
}
