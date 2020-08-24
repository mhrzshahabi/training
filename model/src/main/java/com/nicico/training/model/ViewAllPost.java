
/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/08/24
 * Last Modified: 2020/07/26
 */

package com.nicico.training.model;

import com.nicico.training.model.compositeKey.ViewAllPostReportKey;
import com.nicico.training.model.compositeKey.ViewStatisticsUnitReportKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_all_posts")
public class ViewAllPost implements Serializable {

    @EmbeddedId
    private ViewAllPostReportKey id;

    @Column(name = "postid", insertable = false, updatable = false)
    private Long postId;

    @Column(name = "e_enabled")
    private Long enabled;

    @Column(name = "e_deleted")
    private Long deleted;

    @Column(name = "n_version")
    private Integer version;

    @Column(name = "c_affairs")
    private String affairs;

    @Column(name = "c_area")
    private String area;

    @Column(name = "c_assistance")
    private String assistance;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_cost_center_code")
    private String costCenterCode;

    @Column(name = "c_cost_center_title_fa")
    private String costCenterTitleFa;

    @Column(name = "c_section")
    private String section;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_unit")
    private String unit;

    @Column(name = "c_people_type")
    private String peopleType;

    @Column(name = "jobtitle")
    private String jobTitle;

    @Column(name = "postgradetitle")
    private String postGradeTitle;

    @Column(name = "groupid", insertable = false, updatable = false)
    private Long groupid;

    @Column(name = "type", insertable = false, updatable = false)
    private Integer type;

}
