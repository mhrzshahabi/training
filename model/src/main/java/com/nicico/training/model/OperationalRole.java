package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_operational_role")
public class OperationalRole extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "OPERATIONAL_ROLE_SEQ")
    @SequenceGenerator(name = "OPERATIONAL_ROLE_SEQ", sequenceName = "SEQ_OPERATIONAL_ROLE_ID", allocationSize = 1)
    @Column(name = "ID", precision = 10)
    private Long id;

    @Column(name = "C_CODE", nullable = false, unique = true)
    private String code;

    @Column(name = "C_TITLE", nullable = false, unique = true)
    private String title;

    @Column(name = "C_DESCRIPTION")
    private String description;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "F_OPERATIONAL_UNIT_ID", insertable = false, updatable = false)
    private OperationalUnit operationalUnit;

    @Column(name = "F_OPERATIONAL_UNIT_ID")
    private Long operationalUnitId;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "TBL_OPERATIONAL_ROLE_USER_IDS", joinColumns = @JoinColumn(name = "F_OPERATIONAL_ROLE"))
    @Column(name = "USER_IDS")
    private Set<Long> userIds;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "TBL_OPERATIONAL_ROLE_POST_IDS", joinColumns = @JoinColumn(name = "F_OPERATIONAL_ROLE"))
    @Column(name = "POST_IDS")
    private Set<Long> postIds;

    @Column(name = "COMPLEX_ID")
    private Long complexId;
}
