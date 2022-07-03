package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.envers.NotAudited;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_operational_chart")
public class OperationalChart extends Auditable{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "operational_chart_seq")
    @SequenceGenerator(name = "operational_chart_seq", sequenceName = "seq_operational_chart_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title")
    private String title;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "c_complex")
    private String complex;

    @Column(name = "c_username")
    private String userName;

    @Column(name = "c_nationalcode")
    private String nationalCode;

    @OneToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_operational_chart_parent_child", uniqueConstraints = {@UniqueConstraint(columnNames = {"parent_id", "child_id"})},
            joinColumns = {@JoinColumn(name = "parent_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "child_id", referencedColumnName = "id")})
    private List<OperationalChart> operationalChartParentChild;

}
