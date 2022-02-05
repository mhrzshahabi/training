package com.nicico.training.repository;

import com.nicico.training.model.ViewAllPost;
import com.nicico.training.model.compositeKey.ViewAllPostReportKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewAllPostReportDAO extends JpaRepository<ViewAllPost, ViewAllPostReportKey>, JpaSpecificationExecutor<ViewAllPost> {

    List<ViewAllPost> findViewAllPostByGroupid(Long groupid);
}
