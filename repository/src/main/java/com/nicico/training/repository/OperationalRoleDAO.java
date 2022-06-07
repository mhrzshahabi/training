package com.nicico.training.repository;

import com.nicico.training.model.OperationalRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface OperationalRoleDAO extends JpaRepository<OperationalRole, Long>, JpaSpecificationExecutor<OperationalRole> {

    Boolean findByCode(@Param("code") String roleCode);

    boolean existsOperationalRoleByCode(String roleCode);

    @Query(value = "SELECT rp.POST_IDS FROM TBL_OPERATIONAL_ROLE_POST_IDS rp where rp.F_OPERATIONAL_ROLE <> :roleId ", nativeQuery = true)
    List<Long> getUsedPostIdsInRoles(@Param("roleId")Long roleId);

   Optional<OperationalRole> findByPostIds(Long postId);

   List<OperationalRole> findAllByPostIds(Long postId);

    /**
     * it returns the id of posts which user has access to them in operational role
     *
     * @param userId
     * @return
     */
//    @Query(value = "SELECT postIds.POST_IDS FROM TBL_OPERATIONAL_ROLE role LEFT JOIN TBL_OPERATIONAL_ROLE_USER_IDS userIds ON role.ID = userIds.F_OPERATIONAL_ROLE " +
//            " LEFT JOIN TBL_OPERATIONAL_ROLE_POST_IDS postIds ON role.ID = postIds.F_OPERATIONAL_ROLE WHERE userIds.USER_IDS = :userId ", nativeQuery = true)
    @Query(value = "SELECT post.ID " +
            " FROM TBL_POST post " +
            "          LEFT JOIN TBL_POST_TRAINING_POST TPTP ON post.ID = TPTP.F_POST_ID " +
            "          LEFT JOIN TBL_TRAINING_POST TTP ON TPTP.F_TRAINING_POST_ID = TTP.ID " +
            " WHERE TTP.ID IN " +
            "       (SELECT postIds.POST_IDS " +
            "        FROM TBL_OPERATIONAL_ROLE role " +
            "                 LEFT JOIN TBL_OPERATIONAL_ROLE_USER_IDS userIds ON role.ID = userIds.F_OPERATIONAL_ROLE " +
            "                 LEFT JOIN TBL_OPERATIONAL_ROLE_POST_IDS postIds ON role.ID = postIds.F_OPERATIONAL_ROLE " +
            "        WHERE userIds.USER_IDS = :userId) ", nativeQuery = true)
    List<Long> getUserAccessPostsInRole(@Param("userId") Long userId);

//    /**
//     * it returns the id of training posts which user has access to them in operational role
//     * @param userId
//     * @return
//     */
//    @Query(value = "SELECT ttp.ID FROM tbl_training_post ttp LEFT JOIN TBL_POST_TRAINING_POST TPTP ON ttp.ID = TPTP.F_TRAINING_POST_ID " +
//            " LEFT JOIN TBL_POST tp ON TPTP.F_POST_ID = tp.ID WHERE tp.ID IN (SELECT postIds.POST_IDS " +
//            "FROM TBL_OPERATIONAL_ROLE role " +
//            "         LEFT JOIN TBL_OPERATIONAL_ROLE_USER_IDS userIds ON role.ID = userIds.F_OPERATIONAL_ROLE " +
//            "         LEFT JOIN TBL_OPERATIONAL_ROLE_POST_IDS postIds ON role.ID = postIds.F_OPERATIONAL_ROLE " +
//            "WHERE userIds.USER_IDS = :userId) ", nativeQuery = true)
//    Set<Long> getUserAccessTrainingPostsInRole(@Param("userId") Long userId);
    /**
     * it returns the id of training posts which user has access to them in operational role
     *
     * @param userId
     * @return
     */
    @Query(value = "SELECT postIds.POST_IDS FROM TBL_OPERATIONAL_ROLE role " +
            " LEFT JOIN TBL_OPERATIONAL_ROLE_USER_IDS userIds ON role.ID = userIds.F_OPERATIONAL_ROLE " +
            " LEFT JOIN TBL_OPERATIONAL_ROLE_POST_IDS postIds ON role.ID = postIds.F_OPERATIONAL_ROLE " +
            " WHERE userIds.USER_IDS = :userId ", nativeQuery = true)
    Set<Long> getUserAccessTrainingPostsInRole(@Param("userId") Long userId);

    /**
     * WE NEEDED TO RETURN THE OAUTH USER ID BY OPERATIONAL ROLE CODE
     * @param roleCode
     * @return
     */
    @Query(value = "select ouser.USER_IDS " +
            "from TBL_OPERATIONAL_ROLE_USER_IDS ouser " +
            "         inner join TBL_OPERATIONAL_ROLE role on role.ID = ouser.F_OPERATIONAL_ROLE " +
            "where role.C_CODE = :roleCode " , nativeQuery = true)
    Long findRoleByCode(@Param("roleCode") String roleCode);
}
