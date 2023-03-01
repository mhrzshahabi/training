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

   List<OperationalRole> findAllByPostIdsAndComplexIdAndObjectType(Long postId, Long complexId, String objectType);

   List<OperationalRole> findAllByComplexIdAndObjectType(Long complexId, String objectType);

   List<OperationalRole> findAllByObjectType( String objectType);

    @Query(value = "SELECT \n" +
            "DISTINCT\n" +
            "post.ID \n" +
            "             FROM TBL_POST post \n" +
            "                      INNER JOIN TBL_POST_TRAINING_POST TPTP ON post.ID = TPTP.F_POST_ID\n" +
            "                      INNER JOIN TBL_TRAINING_POST TTP ON TPTP.F_TRAINING_POST_ID = TTP.ID \n" +
            "             WHERE TTP.ID IN \n" +
            "                  (SELECT postIds.POST_IDS \n" +
            "                   FROM TBL_OPERATIONAL_ROLE role \n" +
            "                             INNER JOIN TBL_OPERATIONAL_ROLE_USER_IDS userIds ON role.ID = userIds.F_OPERATIONAL_ROLE \n" +
            "                            INNER JOIN TBL_OPERATIONAL_ROLE_POST_IDS postIds ON role.ID = postIds.F_OPERATIONAL_ROLE \n" +
            "                   WHERE userIds.USER_IDS = :userId)", nativeQuery = true)
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
    @Query(value = "SELECT \n" +
            "DISTINCT\n" +
            "postIds.POST_IDS FROM TBL_OPERATIONAL_ROLE role \n" +
            "        INNER JOIN TBL_OPERATIONAL_ROLE_USER_IDS userIds ON role.ID = userIds.F_OPERATIONAL_ROLE \n" +
            "            INNER JOIN TBL_OPERATIONAL_ROLE_POST_IDS postIds ON role.ID = postIds.F_OPERATIONAL_ROLE \n" +
            "            WHERE userIds.USER_IDS = :userId", nativeQuery = true)
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

    @Query(value = "SELECT opr.id FROM (SELECT id FROM tbl_operational_role WHERE complex_id =:complexId AND object_type =:objectType) opr " +
            "INNER JOIN tbl_operational_role_subcategory orsc ON orsc.f_operational_role = opr.id WHERE orsc.f_subcategory =:subCategoryId", nativeQuery = true)
    List<Long> getOperationalRoleIdsByComplexIdAndSubCategoryId(Long complexId, String objectType, Long subCategoryId);

    @Query(value = "SELECT opr.id FROM (SELECT id FROM tbl_operational_role WHERE complex_id =:complexId AND object_type =:objectType) opr " +
            "INNER JOIN tbl_operational_role_category orc ON orc.f_operational_role = opr.id WHERE orc.f_category =:categoryId", nativeQuery = true)
    List<Long> getOperationalRoleIdsByComplexIdAndCategoryId(Long complexId, String objectType, Long categoryId);


    @Query(value = "SELECT\n" +
            "    f_category FROM tbl_operational_role_category WHERE\n" +
            "    F_OPERATIONAL_ROLE = :id " , nativeQuery = true)
    List<Long> getCategoriesIdes(Long id);

    @Query(value = "SELECT\n" +
            "    F_SUBCATEGORY FROM TBL_OPERATIONAL_ROLE_SUBCATEGORY WHERE\n" +
            "    F_OPERATIONAL_ROLE = :id " , nativeQuery = true)
    List<Long> getSubCategories(Long id);


    @Query(value = """
SELECT
    tbl_operational_role_user_ids.user_ids as id
FROM
         tbl_operational_role
    INNER JOIN tbl_operational_role_user_ids ON tbl_operational_role.id = tbl_operational_role_user_ids.
    f_operational_role
    WHERE object_type = 'EXECUTIVE_SUPERVISOR'
    and user_ids = :id
""" , nativeQuery = true)
    List<Long> isSupervisor(@Param("id") Long userId);


    @Query(value = """
SELECT DISTINCT
    *
FROM
         tbl_operational_role
    INNER JOIN tbl_operational_role_user_ids ON tbl_operational_role.id = tbl_operational_role_user_ids.f_operational_role
    INNER JOIN tbl_operational_role_subcategory ON tbl_operational_role_user_ids.f_operational_role =\s
    tbl_operational_role_subcategory.f_operational_role
    INNER JOIN tbl_course ON tbl_operational_role_subcategory.f_subcategory = tbl_course.
    subcategory_id
WHERE

   \s
     tbl_operational_role.object_type = :objectType
    and tbl_course.c_code = :code
""" , nativeQuery = true)
    List<OperationalRole> findAllByObjectTypeAndPermission(String objectType, String code);
}
