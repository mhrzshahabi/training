/*
ghazanfari_f, 8/29/2019, 10:43 AM
*/
package com.nicico.training.repository;

import com.nicico.training.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.Optional;

@Repository
public interface PostDAO extends JpaRepository<Post, Long>, JpaSpecificationExecutor<Post> {

//    @Query(value = "select p.* from tbl_post p where p.f_job_id = ?1", countQuery = "SELECT count(*) from tbl_post p where p.f_job_id = ?1", nativeQuery = true)
//    Page<Post> findAllByJobId(Long jobId, Pageable pageable);

    @Query(value = "select p.* from tbl_post p where p.f_job_id = ?1", nativeQuery = true)
    Page<Post> findAllByJobId(Long jobId, Pageable pageable);

//    Optional<Post> findOneById(Long postId);

    @Query(value = "select C_CODE from tbl_post   where (ID=:postId )", nativeQuery = true)
    String findOneById(@Param("postId") Long postId);

    Optional<Post> findByCode(@Param("code") String code);
    Optional<Post> findByCodeAndDeleted(@Param("code") String code,Long deleted);

    @Modifying
    @Query(value = "update TBL_POST set D_LAST_MODIFIED_DATE_NA = :modificationDate, C_MODIFIED_BY_NA = :userName ,N_VERSION = N_VERSION + 1 where ID = :objectId", nativeQuery = true)
    public int updateModifications(Long objectId, Date modificationDate, String userName);

    Optional<Post> findFirstById(Long id);

}
