/*
ghazanfari_f, 8/29/2019, 10:43 AM
*/
package com.nicico.training.repository;

import com.nicico.training.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface PostDAO extends JpaRepository<Post, Long>, JpaSpecificationExecutor<Post> {

//    @Query(value = "select p.* from training.tbl_post p where p.f_job_id = ?1", countQuery = "SELECT count(*) from training.tbl_post p where p.f_job_id = ?1", nativeQuery = true)
//    Page<Post> findAllByJobId(Long jobId, Pageable pageable);

    @Query(value = "select p.* from training.tbl_post p where p.f_job_id = ?1", nativeQuery = true)
    Page<Post> findAllByJobId(Long jobId, Pageable pageable);
}
