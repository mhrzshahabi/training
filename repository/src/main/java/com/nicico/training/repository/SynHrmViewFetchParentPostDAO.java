package com.nicico.training.repository;

import com.nicico.training.model.SynHrmViewFetchParentPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface SynHrmViewFetchParentPostDAO extends JpaRepository<SynHrmViewFetchParentPost, Long>, JpaSpecificationExecutor<SynHrmViewFetchParentPost> {

    @Query(value = "SELECT\n" +
            "     \n" +
            "    syn_hrm_view_fetch_parent_post.c_national_code_prnt_output\n" +
            "FROM\n" +
            "    syn_hrm_view_fetch_parent_post\n" +
            "    WHERE\n" +
            "    syn_hrm_view_fetch_parent_post.c_national_code_input = :nationalCode", nativeQuery = true)
    String getParent(String nationalCode);

}
