package com.nicico.training.repository;

import com.nicico.training.model.PostGradeGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface PostGradeGroupDAO extends JpaRepository<PostGradeGroup, Long>, JpaSpecificationExecutor<PostGradeGroup> {

    @Modifying
    @Query(value = "update TBL_POST_GRADE_GROUP set D_LAST_MODIFIED_DATE_NA = :modificationDate, C_MODIFIED_BY_NA = :userName,N_VERSION = N_VERSION + 1 where ID = :objectId", nativeQuery = true)
    public int updateModifications(Long objectId, Date modificationDate, String userName);

    @Modifying
    @Query(value = "SELECT\n" +
            "    F_POST_GRADE_GROUP_ID FROM tbl_post_grade_post_grade_group\n" +
            "    WHERE\n" +
            "    F_POST_GRADE_ID = :id", nativeQuery = true)
    List<Long> getAllPostGroupIdByPostGradeId(Long id);
}
