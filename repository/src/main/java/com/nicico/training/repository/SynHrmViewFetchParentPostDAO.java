package com.nicico.training.repository;

import com.nicico.training.model.SynHrmViewFetchParentPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface SynHrmViewFetchParentPostDAO extends JpaRepository<SynHrmViewFetchParentPost, Long>, JpaSpecificationExecutor<SynHrmViewFetchParentPost> {

    @Query(value = """
SELECT
   rowNum AS id,  res.*\s
 FROM (
    SELECT
        * FROM syn_hrm_view_fetch_parent_post
WHERE
    syn_hrm_view_fetch_parent_post.c_national_code_input = :nationalCode) res
""", nativeQuery = true)
    SynHrmViewFetchParentPost getParent(String nationalCode);

}
