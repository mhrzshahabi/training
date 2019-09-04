/*
ghazanfari_f, 8/29/2019, 10:43 AM
*/
package com.nicico.training.repository;

import com.nicico.training.model.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PostDAO extends JpaRepository<Post, Long>, JpaSpecificationExecutor<Post> {
}
