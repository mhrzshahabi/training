package com.nicico.training.repository;

import com.nicico.training.model.GroupOfPersonnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GroupOfPersonnelDAO extends JpaRepository<GroupOfPersonnel, Long>, JpaSpecificationExecutor<GroupOfPersonnel> {

//    @Modifying
//    @Query(value = "update TBL_POST_GRADE_GROUP set D_LAST_MODIFIED_DATE_NA = :modificationDate, C_MODIFIED_BY_NA = :userName,N_VERSION = N_VERSION + 1 where ID = :objectId", nativeQuery = true)
//    public int updateModifications(Long objectId, Date modificationDate, String userName);
//
    @Modifying
    @Query(value = "SELECT\n" +
            "f_personnel_id\n" +
            "               F_POST_GRADE_GROUP_ID FROM tbl_personnel_in_group \n" +
            "                 WHERE\n" +
            "               f_group_id = :id", nativeQuery = true)
    List<Long> getAllPersonnelByGroupId(Long id);


    Optional<GroupOfPersonnel> findFirstByCode(String code);
}
