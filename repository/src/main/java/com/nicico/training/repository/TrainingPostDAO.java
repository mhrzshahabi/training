package com.nicico.training.repository;

import com.nicico.training.model.TrainingPost;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface TrainingPostDAO extends BaseDAO<TrainingPost, Long> {

    @Modifying
    @Query(value = "update TBL_TRAINING_POST set D_LAST_MODIFIED_DATE_NA = :modificationDate, C_MODIFIED_BY_NA = :userName,N_VERSION = N_VERSION + 1 where ID = :objectId", nativeQuery = true)
    public int updateModifications(Long objectId, Date modificationDate, String userName);

    @Query(value = "SELECT DISTINCT  p.C_AREA FROM TBL_TRAINING_POST p WHERE p.C_AREA is not null order by p.C_AREA", nativeQuery = true)
    List<String> findAllArea();

    Optional<TrainingPost> findFirstByCode(String code);

    Optional<TrainingPost> findByCodeAndDeleted(@Param("code") String code, Long deleted);

    @Modifying
    @Query(value = "UPDATE TBL_TRAINING_POST SET E_DELETED = NULL WHERE ID = :trainingPostId", nativeQuery = true)
    void setNullToDeleted(@Param("trainingPostId") Long trainingPostId);

    @Modifying
    @Query(value = "SELECT\n" +
            "    f_training_post_id FROM tbl_post_training_post \n" +
            "    WHERE f_post_id = :id", nativeQuery = true)
    List<Long> getAllTrainingPostIdByPostId(Long id);


    @Modifying
    @Query(value = "SELECT\n" +
            " DISTINCT\n" +
            "    z.id AS id\n" +
            "FROM\n" +
            "    tbl_post\n" +
            "    LEFT JOIN tbl_training_post z   ON regexp_substr(tbl_post.c_code, '\\d*') = z.c_code\n" +
            "WHERE\n" +
            "    tbl_post.e_deleted IS NULL\n" +
            "    and\n" +
            "    z.e_deleted = 75", nativeQuery = true)
    List<Long> getDeletedPost();
}
