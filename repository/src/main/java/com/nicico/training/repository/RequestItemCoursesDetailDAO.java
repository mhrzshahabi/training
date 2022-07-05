package com.nicico.training.repository;

import com.nicico.training.model.RequestItemCoursesDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RequestItemCoursesDetailDAO extends JpaRepository<RequestItemCoursesDetail, Long>, JpaSpecificationExecutor<RequestItemCoursesDetail> {

    List<RequestItemCoursesDetail> findAllByRequestItemProcessDetailId(Long requestItemProcessDetailId);

    @Query(value = "SELECT * FROM tbl_request_item_courses_detail WHERE f_request_item_process_detail_id IN (:requestItemProcessDetailIds)",nativeQuery = true)
    List<RequestItemCoursesDetail> findAllByRequestItemProcessDetailIds(List<Long> requestItemProcessDetailIds);
}
