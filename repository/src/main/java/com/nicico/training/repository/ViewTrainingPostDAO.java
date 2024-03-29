package com.nicico.training.repository;

import com.nicico.training.model.ViewTrainingPost;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewTrainingPostDAO extends BaseDAO<ViewTrainingPost, Long> {

    @Query(value = "SELECT tpost.* FROM VIEW_TRAINING_POST tpost INNER JOIN TBL_NEEDS_ASSESSMENT needAssesment ON (needAssesment.C_OBJECT_CODE = tpost.C_CODE ) WHERE needAssesment.F_SKILL =:skillId AND needAssesment.C_OBJECT_TYPE = 'TrainingPost'", nativeQuery = true)
    List<ViewTrainingPost> getPostsContainsTheSkill(Long skillId);

    @Query(value = "SELECT TP.* FROM VIEW_TRAINING_POST TP INNER JOIN TBL_OPERATIONAL_ROLE_POST_IDS rolePosts ON rolePosts.POST_IDS = TP.ID WHERE F_OPERATIONAL_ROLE = :roleId ", nativeQuery = true)
    List<ViewTrainingPost> getRoleUsedPostList(@Param("roleId") Long roleId);
    @Query(value = "SELECT TP.* FROM VIEW_TRAINING_POST TP LEFT JOIN TBL_OPERATIONAL_ROLE_POST_IDS rolePosts ON rolePosts.POST_IDS = TP.ID ", nativeQuery = true)
    List<ViewTrainingPost> getNonUsedRolePostList();
}
